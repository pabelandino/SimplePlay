//
//  SectionAudioCacheTests.swift
//  LvoqPlaybackTests
//

import AVFoundation
import Foundation
import Testing
@testable import LvoqPlayback

@Suite struct SectionAudioCacheTests {
    @Test func sourceRangeClipsToSectionAndClip() {
        let clip = AudioClip(
            name: "Clip",
            fileURL: URL(fileURLWithPath: "/tmp/clip.wav"),
            startTime: 8,
            duration: 20,
            sourceOffset: 1
        )
        let range = SectionAudioCache.sourceRange(
            clip: clip,
            timelineStart: 10,
            timelineEnd: 16,
            sampleRate: 44_100
        )
        #expect(range != nil)
        let sourceStart = range?.sourceStart ?? -1
        let frameCount = range?.frameCount ?? 0
        // timeline 10 is 2s into the clip; sourceOffset 1s → source start at 3s
        #expect(sourceStart == TimelineSampleGrid.frames(at: 3, sampleRate: 44_100))
        #expect(frameCount == AVAudioFrameCount(TimelineSampleGrid.frames(at: 6, sampleRate: 44_100)))
    }

    @Test func sourceRangeNilWhenClipMissesSection() {
        let clip = AudioClip(
            name: "Clip",
            fileURL: URL(fileURLWithPath: "/tmp/clip.wav"),
            startTime: 0,
            duration: 4
        )
        let range = SectionAudioCache.sourceRange(
            clip: clip,
            timelineStart: 10,
            timelineEnd: 16,
            sampleRate: 44_100
        )
        #expect(range == nil)
    }

    @Test func continuationTailIsCapped() {
        let clip = AudioClip(
            name: "Clip",
            fileURL: URL(fileURLWithPath: "/tmp/clip.wav"),
            startTime: 0,
            duration: 120
        )
        let range = SectionAudioCache.continuationTailRange(
            clip: clip,
            sectionEnd: 10,
            sampleRate: 44_100
        )
        #expect(range != nil)
        #expect(
            range?.frameCount
                == AVAudioFrameCount(TimelineSampleGrid.frames(at: 8, sampleRate: 44_100))
        )
    }

    @Test func sliceBudgetRejectsLongSections() {
        let frames = AVAudioFrameCount(44_100 * 90)
        #expect(!SectionAudioCache.isSliceWithinBudget(frameCount: frames, sampleRate: 44_100))
        let short = AVAudioFrameCount(44_100 * 8)
        #expect(SectionAudioCache.isSliceWithinBudget(frameCount: short, sampleRate: 44_100))
    }

    @Test func normalizedPathUnifiesSymlinkedRoots() {
        let viaVar = URL(fileURLWithPath: "/var/tmp")
        let viaPrivate = URL(fileURLWithPath: "/private/var/tmp")
        #expect(
            SectionAudioCache.normalizedPath(viaVar) == SectionAudioCache.normalizedPath(viaPrivate)
        )
    }

    @Test @MainActor func cachedIfPresentDoesNotDecodeMissingFiles() {
        let cache = SectionAudioCache()
        #expect(
            cache.cachedIfPresent(
                sectionID: UUID(),
                clipID: UUID(),
                sourceStartFrame: 0,
                frameCount: 1024
            ) == nil
        )
    }

    @Test func sectionClipFallbackIgnoresFrameRounding() {
        let sectionID = UUID()
        let clipID = UUID()
        let exact = SectionAudioCache.Key(
            sectionID: sectionID,
            clipID: clipID,
            sourceStartFrame: 100,
            frameCount: 50
        )
        let rounded = SectionAudioCache.Key(
            sectionID: sectionID,
            clipID: clipID,
            sourceStartFrame: 101,
            frameCount: 49
        )
        #expect(exact != rounded)
        #expect(exact.sectionID == rounded.sectionID && exact.clipID == rounded.clipID)
    }

    @Test func padLayoutPutsShortClipInsideSectionLength() {
        let clip = AudioClip(
            name: "Clip",
            fileURL: URL(fileURLWithPath: "/tmp/clip.wav"),
            startTime: 12,
            duration: 2
        )
        let layout = SectionAudioCache.padLayout(
            clip: clip,
            sectionStart: 10,
            sectionEnd: 20,
            sampleRate: 44_100
        )
        #expect(layout != nil)
        let sectionFrames = layout?.sectionFrames ?? 0
        let destOffset = layout?.destOffset ?? 0
        let overlap = layout?.overlapFrames ?? 0
        #expect(sectionFrames == AVAudioFrameCount(TimelineSampleGrid.frames(at: 10, sampleRate: 44_100)))
        #expect(destOffset == AVAudioFrameCount(TimelineSampleGrid.frames(at: 2, sampleRate: 44_100)))
        #expect(overlap == AVAudioFrameCount(TimelineSampleGrid.frames(at: 2, sampleRate: 44_100)))
        #expect(Int(destOffset) + Int(overlap) <= Int(sectionFrames))
    }

    @Test func padOverlapIsSectionLengthAndSilentOutsideClip() {
        let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)!
        let overlap = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: 4)!
        overlap.frameLength = 4
        overlap.floatChannelData?[0][0] = 1
        overlap.floatChannelData?[0][1] = 1
        overlap.floatChannelData?[0][2] = 1
        overlap.floatChannelData?[0][3] = 1
        let padded = SectionAudioCache.padOverlap(overlap, destOffset: 2, sectionFrames: 8)
        #expect(padded?.frameLength == 8)
        #expect(padded?.floatChannelData?[0][0] == 0)
        #expect(padded?.floatChannelData?[0][1] == 0)
        #expect(padded?.floatChannelData?[0][2] == 1)
        #expect(padded?.floatChannelData?[0][5] == 1)
        #expect(padded?.floatChannelData?[0][6] == 0)
    }
}
