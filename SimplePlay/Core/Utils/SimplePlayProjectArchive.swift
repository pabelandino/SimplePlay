//
//  SimplePlayProjectArchive.swift
//  SimplePlay
//

import Foundation

enum SimplePlayProjectArchiveError: LocalizedError {
    case invalidArchive
    case corruptManifest
    case corruptAsset(String)

    var errorDescription: String? {
        switch self {
        case .invalidArchive: "Invalid SimplePlay project file."
        case .corruptManifest: "Project manifest is corrupt."
        case .corruptAsset(let name): "Project asset is corrupt: \(name)"
        }
    }
}

/// Single-file SimplePlay project container readable on iPhone, iPad, and macOS.
enum SimplePlayProjectArchive {
    private static let magic = Data("SPL1".utf8)

    struct Asset: Sendable {
        let relativePath: String
        let data: Data
    }

    static func makeData(manifest: Data, assets: [Asset]) -> Data {
        var payload = Data()
        payload.append(magic)
        appendUInt64(UInt64(manifest.count), to: &payload)
        payload.append(manifest)
        appendUInt32(UInt32(assets.count), to: &payload)

        for asset in assets {
            let nameData = Data(asset.relativePath.utf8)
            appendUInt16(UInt16(nameData.count), to: &payload)
            payload.append(nameData)
            appendUInt64(UInt64(asset.data.count), to: &payload)
            payload.append(asset.data)
        }

        return payload
    }

    static func write(manifest: Data, assets: [Asset], to url: URL) throws {
        let payload = makeData(manifest: manifest, assets: assets)
        let resolvedURL = normalizedFileURL(url)

        if FileManager.default.fileExists(atPath: resolvedURL.path) {
            try FileManager.default.removeItem(at: resolvedURL)
        }

        try payload.write(to: resolvedURL, options: .atomic)
    }

    static func read(from url: URL) throws -> (manifest: Data, assets: [Asset]) {
        let data = try Data(contentsOf: normalizedFileURL(url))
        guard data.count >= 16, data.prefix(4) == magic else {
            throw SimplePlayProjectArchiveError.invalidArchive
        }

        var offset = 4
        guard let manifestSize = readUInt64BE(from: data, offset: &offset) else {
            throw SimplePlayProjectArchiveError.corruptManifest
        }

        let manifestEnd = offset + Int(manifestSize)
        guard manifestEnd <= data.count else {
            throw SimplePlayProjectArchiveError.corruptManifest
        }

        let manifest = data.subdata(in: offset..<manifestEnd)
        offset = manifestEnd

        guard let assetCount = readUInt32BE(from: data, offset: &offset) else {
            throw SimplePlayProjectArchiveError.corruptManifest
        }

        var assets: [Asset] = []
        assets.reserveCapacity(Int(assetCount))

        for _ in 0..<assetCount {
            guard let nameLength = readUInt16BE(from: data, offset: &offset),
                  offset + Int(nameLength) <= data.count
            else {
                throw SimplePlayProjectArchiveError.corruptManifest
            }

            let nameData = data.subdata(in: offset..<(offset + Int(nameLength)))
            offset += Int(nameLength)

            guard let relativePath = String(data: nameData, encoding: .utf8),
                  let dataLength = readUInt64BE(from: data, offset: &offset)
            else {
                throw SimplePlayProjectArchiveError.corruptManifest
            }

            let dataEnd = offset + Int(dataLength)
            guard dataEnd <= data.count else {
                throw SimplePlayProjectArchiveError.corruptAsset(relativePath)
            }

            let assetData = data.subdata(in: offset..<dataEnd)
            offset = dataEnd
            assets.append(Asset(relativePath: relativePath, data: assetData))
        }

        return (manifest, assets)
    }

    static func isArchiveFile(at url: URL) -> Bool {
        guard let handle = try? FileHandle(forReadingFrom: normalizedFileURL(url)) else {
            return false
        }
        defer { try? handle.close() }

        guard let prefix = try? handle.read(upToCount: 4) else { return false }
        return prefix == magic
    }

    private static func normalizedFileURL(_ url: URL) -> URL {
        if url.pathExtension.isEmpty {
            return url.appendingPathExtension(SimplePlayProjectType.fileExtension)
        }
        return url
    }

    private static func appendUInt16(_ value: UInt16, to data: inout Data) {
        var bigEndian = value.bigEndian
        data.append(Data(bytes: &bigEndian, count: MemoryLayout<UInt16>.size))
    }

    private static func appendUInt32(_ value: UInt32, to data: inout Data) {
        var bigEndian = value.bigEndian
        data.append(Data(bytes: &bigEndian, count: MemoryLayout<UInt32>.size))
    }

    private static func appendUInt64(_ value: UInt64, to data: inout Data) {
        var bigEndian = value.bigEndian
        data.append(Data(bytes: &bigEndian, count: MemoryLayout<UInt64>.size))
    }

    private static func readUInt16BE(from data: Data, offset: inout Int) -> UInt16? {
        let size = MemoryLayout<UInt16>.size
        guard offset + size <= data.count else { return nil }
        let value = data.subdata(in: offset..<(offset + size)).withUnsafeBytes {
            $0.load(as: UInt16.self)
        }
        offset += size
        return UInt16(bigEndian: value)
    }

    private static func readUInt32BE(from data: Data, offset: inout Int) -> UInt32? {
        let size = MemoryLayout<UInt32>.size
        guard offset + size <= data.count else { return nil }
        let value = data.subdata(in: offset..<(offset + size)).withUnsafeBytes {
            $0.load(as: UInt32.self)
        }
        offset += size
        return UInt32(bigEndian: value)
    }

    private static func readUInt64BE(from data: Data, offset: inout Int) -> UInt64? {
        let size = MemoryLayout<UInt64>.size
        guard offset + size <= data.count else { return nil }
        let value = data.subdata(in: offset..<(offset + size)).withUnsafeBytes {
            $0.load(as: UInt64.self)
        }
        offset += size
        return UInt64(bigEndian: value)
    }
}
