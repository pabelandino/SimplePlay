//
//  LyricPlaySyncClient.swift
//  SimplePlay
//

import Foundation
import Network

/// Network client for Lyriora sync. Runs off the main thread so playback timers
/// and audio clock sync are not blocked by TCP/Bonjour work.
actor LyricPlaySyncClient {
    enum ConnectionState: Equatable, Sendable {
        case idle
        case searching
        case connected(String)
        case failed(String)
    }

    private(set) var connectionState: ConnectionState = .idle

    private var browser: NWBrowser?
    private var resolvedEndpoint: NWEndpoint?
    private var heartbeatTask: Task<Void, Never>?
    private var heartbeatSuspended = false
    private let queue = DispatchQueue(label: "com.simpleplay.lyric-sync", qos: .utility)

    private static let browseTimeout: TimeInterval = 12

    func setConnectionStateHandler(_ handler: @escaping @Sendable (ConnectionState) -> Void) {
        onConnectionStateChange = handler
        handler(connectionState)
    }

    private var onConnectionStateChange: (@Sendable (ConnectionState) -> Void)?

    func startBrowsing() {
        guard browser == nil else { return }
        updateConnectionState(.searching)
        resolvedEndpoint = nil

        let parameters = NWParameters.tcp
        parameters.includePeerToPeer = true
        let browser = NWBrowser(
            for: .bonjour(type: LyricPlaySync.bonjourType, domain: LyricPlaySync.bonjourDomain),
            using: parameters
        )

        browser.stateUpdateHandler = { [weak self] state in
            Task {
                await self?.handleBrowserState(state)
            }
        }

        browser.browseResultsChangedHandler = { [weak self] results, _ in
            Task {
                await self?.handleBrowseResults(results)
            }
        }

        browser.start(queue: queue)
        self.browser = browser
    }

    func stopBrowsing() {
        heartbeatTask?.cancel()
        heartbeatTask = nil
        heartbeatSuspended = false
        browser?.cancel()
        browser = nil
        resolvedEndpoint = nil
        updateConnectionState(.idle)
    }

    func startHeartbeat() {
        guard heartbeatTask == nil else { return }
        heartbeatSuspended = false
        heartbeatTask = Task(priority: .utility) { [weak self] in
            while !Task.isCancelled {
                guard let self else { return }
                let suspended = await self.isHeartbeatSuspended
                if !suspended {
                    try? await self.sendPresenceIfConnected()
                }
                try? await Task.sleep(for: .seconds(5))
            }
        }
    }

    func suspendHeartbeat() {
        heartbeatSuspended = true
    }

    func resumeHeartbeat() {
        heartbeatSuspended = false
    }

    private var isHeartbeatSuspended: Bool {
        heartbeatSuspended
    }

    private func sendPresenceIfConnected() async throws {
        guard resolvedEndpoint != nil else { return }
        try await sendPresence()
    }

    func sendPresence() async throws {
        let response = try await send(
            LyricPlaySyncMessage(kind: .presence),
            resolveHostIfNeeded: false
        )
        guard response.kind == .presenceAck || response.kind == .linkSectionAck else {
            if response.kind == .error, let message = response.errorMessage {
                throw LyricPlaySyncTransportError.serverError(message)
            }
            throw LyricPlaySyncTransportError.unexpectedResponse
        }
    }

    func requestCatalog() async throws -> LyricSlideCatalog {
        let response = try await send(
            LyricPlaySyncMessage(kind: .catalogRequest),
            resolveHostIfNeeded: true
        )
        guard response.kind == .catalogResponse, let catalog = response.catalog else {
            if response.kind == .error, let message = response.errorMessage {
                throw LyricPlaySyncTransportError.serverError(message)
            }
            throw LyricPlaySyncTransportError.unexpectedResponse
        }
        return catalog
    }

    /// Sends showSlide on a short-lived connection without waiting for Lyriora's reply.
    func showSlide(_ command: ShowSlideCommand) {
        Task(priority: .utility) { [weak self] in
            guard let self else { return }
            _ = try? await self.send(
                LyricPlaySyncMessage(kind: .showSlide, showSlide: command),
                resolveHostIfNeeded: false,
                waitForResponse: false
            )
        }
    }

    func linkSection(_ command: LinkSectionCommand) async throws {
        let response = try await send(
            LyricPlaySyncMessage(kind: .linkSection, linkSection: command),
            resolveHostIfNeeded: true
        )
        guard response.kind == .linkSectionAck else {
            if response.kind == .error, let message = response.errorMessage {
                throw LyricPlaySyncTransportError.serverError(message)
            }
            throw LyricPlaySyncTransportError.unexpectedResponse
        }
    }

    private func handleBrowserState(_ state: NWBrowser.State) {
        switch state {
        case .failed(let error):
            updateConnectionState(.failed(error.localizedDescription))
        case .cancelled:
            updateConnectionState(.idle)
        default:
            break
        }
    }

    private func handleBrowseResults(_ results: Set<NWBrowser.Result>) {
        guard let result = results.first else {
            if case .connected = connectionState {
                return
            }
            updateConnectionState(.searching)
            resolvedEndpoint = nil
            return
        }

        switch result.endpoint {
        case .service(let name, _, _, _):
            updateConnectionState(.connected(name))
        default:
            updateConnectionState(.connected(LyricPlaySync.serviceName))
        }

        resolvedEndpoint = result.endpoint
    }

    private func updateConnectionState(_ state: ConnectionState) {
        connectionState = state
        onConnectionStateChange?(state)
    }

    private func send(
        _ message: LyricPlaySyncMessage,
        resolveHostIfNeeded: Bool,
        waitForResponse: Bool = true
    ) async throws -> LyricPlaySyncMessage {
        if resolvedEndpoint == nil {
            if !resolveHostIfNeeded {
                throw LyricPlaySyncTransportError.noLyrioraHost
            }
            startBrowsing()
            try await waitForEndpoint(timeout: Self.browseTimeout)
        }

        guard let endpoint = resolvedEndpoint else {
            throw LyricPlaySyncTransportError.noLyrioraHost
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
                                return
                            }

                            if !waitForResponse {
                                resumeOnce(with: .success(LyricPlaySyncMessage(kind: .presenceAck)))
                                return
                            }

                            receiveResponse()
                        })
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
            throw LyricPlaySyncTransportError.noLyrioraHost
        }
    }
}

enum LyricPlaySyncTransportError: LocalizedError {
    case emptyResponse
    case noLyrioraHost
    case unexpectedResponse
    case serverError(String)

    var errorDescription: String? {
        switch self {
        case .emptyResponse:
            return "Lyriora returned an empty response."
        case .noLyrioraHost:
            return "No Lyriora host found on the local network. Allow local network access for SimplePlay in System Settings if prompted."
        case .unexpectedResponse:
            return "Unexpected response from Lyriora."
        case .serverError(let message):
            return message
        }
    }
}
