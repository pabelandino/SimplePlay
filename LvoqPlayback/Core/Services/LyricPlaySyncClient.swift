//
//  LyricPlaySyncClient.swift
//  LvoqPlayback
//

import Foundation
import Network

@MainActor
final class LyricPlaySyncClient {
    enum ConnectionState: Equatable {
        case idle
        case searching
        case connected(String)
        case failed(String)
    }

    private(set) var connectionState: ConnectionState = .idle

    private var browsers: [NWBrowser] = []
    private var resolvedEndpoint: NWEndpoint?
    private var resolvedBonjourType: String?
    private var heartbeatTask: Task<Void, Never>?
    private let queue = DispatchQueue(label: "com.lvoqplayback.lyric-sync", qos: .userInitiated)

    private static let browseTimeout: TimeInterval = 12

    func startBrowsing() {
        guard browsers.isEmpty else { return }
        connectionState = .searching
        resolvedEndpoint = nil
        resolvedBonjourType = nil

        for type in LyricPlaySync.browseTypes {
            startBrowser(for: type)
        }
    }

    private func startBrowser(for type: String) {
        let parameters = NWParameters.tcp
        parameters.includePeerToPeer = true
        let browser = NWBrowser(
            for: .bonjour(type: type, domain: LyricPlaySync.bonjourDomain),
            using: parameters
        )

        browser.stateUpdateHandler = { _ in
            // One Bonjour type can fail while the other is still browsing.
        }

        browser.browseResultsChangedHandler = { [weak self] results, _ in
            Task { @MainActor in
                self?.handleBrowseResults(results, type: type)
            }
        }

        browser.start(queue: queue)
        browsers.append(browser)
    }

    func stopBrowsing() {
        heartbeatTask?.cancel()
        heartbeatTask = nil
        browsers.forEach { $0.cancel() }
        browsers.removeAll()
        resolvedEndpoint = nil
        resolvedBonjourType = nil
        connectionState = .idle
    }

    func startHeartbeat() {
        guard heartbeatTask == nil else { return }
        heartbeatTask = Task {
            while !Task.isCancelled {
                try? await sendPresence()
                try? await Task.sleep(for: .seconds(5))
            }
        }
    }

    func sendPresence() async throws {
        let response = try await send(LyricPlaySyncMessage(kind: .presence))
        guard response.kind == .presenceAck || response.kind == .linkSectionAck else {
            if response.kind == .error, let message = response.errorMessage {
                throw LyricPlaySyncTransportError.serverError(message)
            }
            throw LyricPlaySyncTransportError.unexpectedResponse
        }
    }

    func requestCatalog() async throws -> LyricSlideCatalog {
        let response = try await send(LyricPlaySyncMessage(kind: .catalogRequest))
        guard response.kind == .catalogResponse, let catalog = response.catalog else {
            if response.kind == .error, let message = response.errorMessage {
                throw LyricPlaySyncTransportError.serverError(message)
            }
            throw LyricPlaySyncTransportError.unexpectedResponse
        }
        return catalog
    }

    func showSlide(_ command: ShowSlideCommand) async throws {
        _ = try await send(
            LyricPlaySyncMessage(kind: .showSlide, showSlide: command)
        )
    }

    func linkSection(_ command: LinkSectionCommand) async throws {
        let response = try await send(
            LyricPlaySyncMessage(kind: .linkSection, linkSection: command)
        )
        guard response.kind == .linkSectionAck else {
            if response.kind == .error, let message = response.errorMessage {
                throw LyricPlaySyncTransportError.serverError(message)
            }
            throw LyricPlaySyncTransportError.unexpectedResponse
        }
    }

    private func handleBrowseResults(_ results: Set<NWBrowser.Result>, type: String) {
        guard let result = results.first else {
            if resolvedBonjourType == type {
                resolvedEndpoint = nil
                resolvedBonjourType = nil
                if case .connected = connectionState {
                    connectionState = .searching
                }
            }
            return
        }

        if resolvedBonjourType == LyricPlaySync.bonjourType, type == LyricPlaySync.legacyBonjourType {
            return
        }

        switch result.endpoint {
        case .service(let name, _, _, _):
            connectionState = .connected(name)
        default:
            connectionState = .connected(LyricPlaySync.serviceName)
        }

        resolvedEndpoint = result.endpoint
        resolvedBonjourType = type
    }

    private func send(_ message: LyricPlaySyncMessage) async throws -> LyricPlaySyncMessage {
        if resolvedEndpoint == nil {
            startBrowsing()
            try await waitForEndpoint(timeout: Self.browseTimeout)
        }

        guard let endpoint = resolvedEndpoint else {
            throw LyricPlaySyncTransportError.noLvoqShowHost
        }

        return try await withCheckedThrowingContinuation { continuation in
            let parameters = NWParameters.tcp
            parameters.includePeerToPeer = true
            let connection = NWConnection(to: endpoint, using: parameters)
            var receivedBuffer = Data()
            var didResume = false

            func resumeOnce(with result: Result<LyricPlaySyncMessage, Error>) {
                guard !didResume else { return }
                didResume = true
                connection.cancel()
                continuation.resume(with: result)
            }

            connection.stateUpdateHandler = { state in
                switch state {
                case .ready:
                    do {
                        let payload = try LyricPlaySyncCodec.encode(message)
                        connection.send(content: payload, completion: .contentProcessed { error in
                            if let error {
                                resumeOnce(with: .failure(error))
                            }
                        })
                        receiveResponse()
                    } catch {
                        resumeOnce(with: .failure(error))
                    }
                case .failed(let error):
                    resumeOnce(with: .failure(error))
                default:
                    break
                }
            }

            func receiveResponse() {
                connection.receive(minimumIncompleteLength: 1, maximumLength: 65_536) { data, _, isComplete, error in
                    if let error {
                        resumeOnce(with: .failure(error))
                        return
                    }

                    if let data {
                        receivedBuffer.append(data)
                    }

                    if receivedBuffer.contains(0x0A) || isComplete {
                        do {
                            let response = try LyricPlaySyncCodec.decode(receivedBuffer)
                            resumeOnce(with: .success(response))
                        } catch {
                            resumeOnce(with: .failure(error))
                        }
                        return
                    }

                    receiveResponse()
                }
            }

            connection.start(queue: queue)
        }
    }

    private func waitForEndpoint(timeout: TimeInterval) async throws {
        let deadline = Date().addingTimeInterval(timeout)
        while resolvedEndpoint == nil, Date() < deadline {
            try await Task.sleep(for: .milliseconds(150))
        }
        if resolvedEndpoint == nil {
            throw LyricPlaySyncTransportError.noLvoqShowHost
        }
    }
}

enum LyricPlaySyncTransportError: LocalizedError {
    case emptyResponse
    case noLvoqShowHost
    case unexpectedResponse
    case serverError(String)

    var errorDescription: String? {
        switch self {
        case .emptyResponse:
            return L10n.Errors.emptyResponse
        case .noLvoqShowHost:
            return L10n.Errors.noHost
        case .unexpectedResponse:
            return L10n.Errors.unexpectedResponse
        case .serverError(let message):
            return message
        }
    }
}
