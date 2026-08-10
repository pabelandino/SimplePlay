//
//  SectionLoopDiagnostics.swift
//  SimplePlay
//

import AVFoundation
import Foundation
import os

enum SectionLoopDiagnostics {
    private static let logger = Logger(subsystem: "SimplePlay", category: "SectionLoop")

    static func log(_ message: String) {
        logger.info("\(message, privacy: .public)")
    }

    static func logPlaybackStart(
        from time: TimeInterval,
        loop: SectionLoopContext?,
        sampleRate: Double
    ) {
        if let loop {
            log(String(
                format: "audio play from %.6fs | loop [%.6f, %.6f) duration %.6fs | sampleRate %.0f",
                time,
                loop.startTime,
                loop.endTime,
                loop.duration,
                sampleRate
            ))
        } else {
            log(String(format: "audio play from %.6fs | no loop | sampleRate %.0f", time, sampleRate))
        }
    }

    static func logTimelineWrap(
        previousTime: TimeInterval,
        newTime: TimeInterval,
        loop: SectionLoopContext,
        action: String
    ) {
        log(String(
            format: "timeline wrap %.6fs -> %.6fs | loop [%.6f, %.6f) | action: %@",
            previousTime,
            newTime,
            loop.startTime,
            loop.endTime,
            action
        ))
    }

    static func logScheduledSegment(
        clipName: String,
        timelineStart: TimeInterval,
        timelineEnd: TimeInterval,
        sourceStartFrame: Int64,
        frameCount: AVAudioFrameCount,
        sampleRate: Double,
        label: String
    ) {
#if DEBUG
        let sourceStartTime = TimelineSampleGrid.timeFromFrame(sourceStartFrame, sampleRate: sampleRate)
        log(String(
            format: "%@ | clip \"%@\" timeline [%.6f, %.6f) source %.6fs frames %llu sr %.0f",
            label,
            clipName,
            timelineStart,
            timelineEnd,
            sourceStartTime,
            frameCount,
            sampleRate
        ))
#endif
    }
}
