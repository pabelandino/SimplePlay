//
//  WorkspaceLayoutContext.swift
//  SimplePlay
//

import SwiftUI

/// Shared layout metrics for cramped phone landscape and manual wrap/compact mode.
struct WorkspaceLayoutContext: Equatable {
    var horizontalSizeClass: UserInterfaceSizeClass?
    var verticalSizeClass: UserInterfaceSizeClass?
    var isTimelineWrapped: Bool = false

    var isPhoneLandscape: Bool {
        DAWTheme.isPhone && verticalSizeClass == .compact
    }

    /// Manual wrap toggle for iPad/mac compact layout.
    var usesWrappedLayout: Bool {
        isTimelineWrapped
    }

    var usesCompactTrackHeaders: Bool {
        horizontalSizeClass == .compact || usesWrappedLayout
    }

    var trackHeaderWidth: CGFloat {
        if isTimelineWrapped {
            return DAWTheme.wrappedTrackHeaderWidth
        }
        if usesCompactTrackHeaders {
            return DAWTheme.compactTrackHeaderWidth
        }
        return DAWTheme.trackHeaderWidth
    }

    var markerLaneHeight: CGFloat {
        if DAWTheme.isPhone {
            return DAWTheme.phoneMarkerLaneHeight
        }
        if isTimelineWrapped {
            return DAWTheme.wrappedMarkerLaneHeight
        }
        return DAWTheme.markerLaneHeight
    }

    var usesSingleLaneTrackSizing: Bool {
        usesWrappedLayout
    }

    func trackRowHeight(trackRowZoom: Double) -> CGFloat {
        if usesSingleLaneTrackSizing {
            let base = DAWTheme.wrappedTrackRowHeight
            return max(DAWTheme.minTrackRowHeight, base * trackRowZoom)
        }

        let base = usesCompactTrackHeaders
            ? DAWTheme.compactTrackRowHeight
            : DAWTheme.trackRowHeight
        return max(DAWTheme.minTrackRowHeight, base * trackRowZoom)
    }
}

private struct WorkspaceLayoutContextKey: EnvironmentKey {
    static let defaultValue = WorkspaceLayoutContext()
}

extension EnvironmentValues {
    var workspaceLayout: WorkspaceLayoutContext {
        get { self[WorkspaceLayoutContextKey.self] }
        set { self[WorkspaceLayoutContextKey.self] = newValue }
    }
}
