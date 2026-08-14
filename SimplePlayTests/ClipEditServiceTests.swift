//
//  ClipEditServiceTests.swift
//  SimplePlayTests
//

import Foundation
import Testing
@testable import SimplePlay

struct ClipEditServiceTests {
    private func sampleClip(
        startTime: TimeInterval = 10,
        duration: TimeInterval = 8,
        sourceOffset: TimeInterval = 2
    ) -> AudioClip {
        AudioClip(
            name: "Stem",
            fileURL: URL(fileURLWithPath: "/tmp/stem.wav"),
            startTime: startTime,
            duration: duration,
            sourceOffset: sourceOffset
        )
    }

    @Test func trimStartAdvancesSourceOffset() {
        let clip = sampleClip()
        let trimmed = ClipEditService.trimStart(clip: clip, to: 12, fileDuration: 20)

        #expect(trimmed?.startTime == 12)
        #expect(trimmed?.duration == 6)
        #expect(trimmed?.sourceOffset == 4)
    }

    @Test func trimStartRejectsMovingLeft() {
        let clip = sampleClip()
        #expect(ClipEditService.trimStart(clip: clip, to: 9, fileDuration: 20) == nil)
    }

    @Test func trimEndShortensDuration() {
        let clip = sampleClip()
        let trimmed = ClipEditService.trimEnd(clip: clip, to: 16, fileDuration: 20)

        #expect(trimmed?.startTime == 10)
        #expect(trimmed?.duration == 6)
        #expect(trimmed?.sourceOffset == 2)
    }

    @Test func trimEndRejectsBelowMinimumDuration() {
        let clip = sampleClip()
        #expect(ClipEditService.trimEnd(clip: clip, to: 10.01, fileDuration: 20) == nil)
    }

    @Test func splitCreatesTwoClipsWithSharedFile() {
        let clip = sampleClip()
        let split = ClipEditService.split(clip: clip, at: 14)

        #expect(split?.left.duration == 4)
        #expect(split?.left.sourceOffset == 2)
        #expect(split?.right.startTime == 14)
        #expect(split?.right.duration == 4)
        #expect(split?.right.sourceOffset == 6)
        #expect(split?.right.fileURL == clip.fileURL)
        #expect(split?.right.groupIndex == clip.groupIndex)
    }

    @Test func splitRejectsPlayheadTooCloseToEdges() {
        let clip = sampleClip()
        #expect(ClipEditService.split(clip: clip, at: 10.02) == nil)
        #expect(ClipEditService.split(clip: clip, at: 17.99) == nil)
    }
}
