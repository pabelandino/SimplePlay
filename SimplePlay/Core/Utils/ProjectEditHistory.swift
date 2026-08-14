//
//  ProjectEditHistory.swift
//  SimplePlay
//

import Foundation

/// Stores reversible snapshots of `DAWProject` for undo/redo.
struct ProjectEditHistory: Sendable {
    private var undoStack: [DAWProject] = []
    private var redoStack: [DAWProject] = []
    private let capacity: Int

    init(capacity: Int = 50) {
        self.capacity = max(1, capacity)
    }

    var canUndo: Bool {
        !undoStack.isEmpty
    }

    var canRedo: Bool {
        !redoStack.isEmpty
    }

    mutating func recordSnapshot(_ project: DAWProject) {
        undoStack.append(project)
        if undoStack.count > capacity {
            undoStack.removeFirst(undoStack.count - capacity)
        }
        redoStack.removeAll()
    }

    mutating func undo(current: DAWProject) -> DAWProject? {
        guard let previous = undoStack.popLast() else { return nil }
        redoStack.append(current)
        return previous
    }

    mutating func redo(current: DAWProject) -> DAWProject? {
        guard let next = redoStack.popLast() else { return nil }
        undoStack.append(current)
        return next
    }

    mutating func clear() {
        undoStack.removeAll()
        redoStack.removeAll()
    }
}
