//
//  ProjectEditHistoryTests.swift
//  SimplePlayTests
//

import XCTest
@testable import SimplePlay

final class ProjectEditHistoryTests: XCTestCase {
    func testUndoRedoRoundTrip() {
        var history = ProjectEditHistory(capacity: 4)
        let original = DAWProject(name: "Original")
        var current = original

        history.recordSnapshot(current)
        current.name = "Edited"
        XCTAssertTrue(history.canUndo)
        XCTAssertFalse(history.canRedo)

        guard let undone = history.undo(current: current) else {
            return XCTFail("Expected undo snapshot")
        }
        current = undone
        XCTAssertEqual(current.name, "Original")
        XCTAssertTrue(history.canRedo)

        guard let redone = history.redo(current: current) else {
            return XCTFail("Expected redo snapshot")
        }
        current = redone
        XCTAssertEqual(current.name, "Edited")
    }

    func testNewEditClearsRedoStack() {
        var history = ProjectEditHistory()
        var current = DAWProject(name: "A")

        history.recordSnapshot(current)
        current.name = "B"
        _ = history.undo(current: current)
        XCTAssertTrue(history.canRedo)

        current.name = "C"
        history.recordSnapshot(current)
        XCTAssertFalse(history.canRedo)
    }
}
