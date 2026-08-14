//
//  SectionTriggerDiagnostics.swift
//  SimplePlay
//

import Foundation
import os

enum SectionTriggerDiagnostics {
    private static let logger = Logger(subsystem: "SimplePlay", category: "SectionTrigger")

    static func log(_ message: String) {
        logger.info("\(message, privacy: .public)")
    }

    static func logTrigger(
        sectionName: String,
        sectionID: UUID,
        result: ArrangementPlaybackEngine.SectionTriggerResult,
        workspacePlaying: Bool,
        arrangementPlaying: Bool,
        audioPlaying: Bool,
        playheadTime: TimeInterval,
        arrangementTime: TimeInterval
    ) {
        log(String(
            format: "trigger \"%@\" id=%@ result=%@ | vmPlaying=%d arrPlaying=%d audioPlaying=%d playhead=%.3fs arrTime=%.3fs",
            sectionName,
            String(sectionID.uuidString.prefix(8)),
            resultLabel(result),
            workspacePlaying ? 1 : 0,
            arrangementPlaying ? 1 : 0,
            audioPlaying ? 1 : 0,
            playheadTime,
            arrangementTime
        ))
    }

    static func logAudioStart(
        source: String,
        time: TimeInterval,
        started: Bool,
        sectionLoop: Bool,
        error: String?
    ) {
        if let error, !started {
            log(String(
                format: "%@ audio start FAILED at %.3fs loop=%d | %@",
                source,
                time,
                sectionLoop ? 1 : 0,
                error
            ))
        } else {
            log(String(
                format: "%@ audio start OK at %.3fs loop=%d",
                source,
                time,
                sectionLoop ? 1 : 0
            ))
        }
    }

    static func logEarlyReturn(_ reason: String, sectionName: String) {
        log(String(format: "trigger \"%@\" early return: %@", sectionName, reason))
    }

    private static func resultLabel(_ result: ArrangementPlaybackEngine.SectionTriggerResult) -> String {
        switch result {
        case .activatedImmediately: return "activatedImmediately"
        case .queuedForEnd: return "queuedForEnd"
        case .enabledRepeatAtEnd: return "enabledRepeatAtEnd"
        }
    }
}
