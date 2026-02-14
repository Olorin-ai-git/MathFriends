//
//  PracticeStatsTests.swift
//  MathFriendsTests
//
//  Unit tests for PracticeStats model
//

import XCTest
@testable import MathFriends

final class PracticeStatsTests: XCTestCase {

    func testInitialStats() {
        let stats = PracticeStats.initial

        XCTAssertEqual(stats.totalAttempted, 0)
        XCTAssertEqual(stats.correct, 0)
        XCTAssertEqual(stats.currentStreak, 0)
        XCTAssertEqual(stats.bestStreak, 0)
        XCTAssertEqual(stats.accuracy, 0)

        XCTAssertEqual(stats.difficultyStats[.easy]?.attempted, 0)
        XCTAssertEqual(stats.difficultyStats[.medium]?.attempted, 0)
        XCTAssertEqual(stats.difficultyStats[.hard]?.attempted, 0)
    }

    func testRecordCorrectAnswer() {
        var stats = PracticeStats.initial

        stats.recordAnswer(correct: true, difficulty: .easy)

        XCTAssertEqual(stats.totalAttempted, 1)
        XCTAssertEqual(stats.correct, 1)
        XCTAssertEqual(stats.currentStreak, 1)
        XCTAssertEqual(stats.bestStreak, 1)
        XCTAssertEqual(stats.accuracy, 1.0)

        XCTAssertEqual(stats.difficultyStats[.easy]?.attempted, 1)
        XCTAssertEqual(stats.difficultyStats[.easy]?.correct, 1)
    }

    func testRecordIncorrectAnswer() {
        var stats = PracticeStats.initial

        stats.recordAnswer(correct: false, difficulty: .easy)

        XCTAssertEqual(stats.totalAttempted, 1)
        XCTAssertEqual(stats.correct, 0)
        XCTAssertEqual(stats.currentStreak, 0)
        XCTAssertEqual(stats.bestStreak, 0)
        XCTAssertEqual(stats.accuracy, 0.0)

        XCTAssertEqual(stats.difficultyStats[.easy]?.attempted, 1)
        XCTAssertEqual(stats.difficultyStats[.easy]?.correct, 0)
    }

    func testStreakIncrements() {
        var stats = PracticeStats.initial

        // Correct answer streak
        stats.recordAnswer(correct: true, difficulty: .easy)
        XCTAssertEqual(stats.currentStreak, 1)

        stats.recordAnswer(correct: true, difficulty: .medium)
        XCTAssertEqual(stats.currentStreak, 2)

        stats.recordAnswer(correct: true, difficulty: .hard)
        XCTAssertEqual(stats.currentStreak, 3)

        XCTAssertEqual(stats.bestStreak, 3)
    }

    func testStreakResetsOnIncorrect() {
        var stats = PracticeStats.initial

        // Build streak
        stats.recordAnswer(correct: true, difficulty: .easy)
        stats.recordAnswer(correct: true, difficulty: .easy)
        stats.recordAnswer(correct: true, difficulty: .easy)
        XCTAssertEqual(stats.currentStreak, 3)

        // Incorrect answer resets current streak
        stats.recordAnswer(correct: false, difficulty: .easy)
        XCTAssertEqual(stats.currentStreak, 0)

        // Best streak is preserved
        XCTAssertEqual(stats.bestStreak, 3)
    }

    func testBestStreakUpdates() {
        var stats = PracticeStats.initial

        // First streak
        stats.recordAnswer(correct: true, difficulty: .easy)
        stats.recordAnswer(correct: true, difficulty: .easy)
        XCTAssertEqual(stats.bestStreak, 2)

        // Reset
        stats.recordAnswer(correct: false, difficulty: .easy)

        // Higher streak
        stats.recordAnswer(correct: true, difficulty: .easy)
        stats.recordAnswer(correct: true, difficulty: .easy)
        stats.recordAnswer(correct: true, difficulty: .easy)
        stats.recordAnswer(correct: true, difficulty: .easy)
        XCTAssertEqual(stats.bestStreak, 4)
        XCTAssertEqual(stats.currentStreak, 4)
    }

    func testDifficultyStatsTrackedSeparately() {
        var stats = PracticeStats.initial

        stats.recordAnswer(correct: true, difficulty: .easy)
        stats.recordAnswer(correct: false, difficulty: .easy)

        stats.recordAnswer(correct: true, difficulty: .medium)
        stats.recordAnswer(correct: true, difficulty: .medium)

        stats.recordAnswer(correct: false, difficulty: .hard)

        XCTAssertEqual(stats.difficultyStats[.easy]?.attempted, 2)
        XCTAssertEqual(stats.difficultyStats[.easy]?.correct, 1)

        XCTAssertEqual(stats.difficultyStats[.medium]?.attempted, 2)
        XCTAssertEqual(stats.difficultyStats[.medium]?.correct, 2)

        XCTAssertEqual(stats.difficultyStats[.hard]?.attempted, 1)
        XCTAssertEqual(stats.difficultyStats[.hard]?.correct, 0)
    }

    func testAccuracyCalculation() {
        var stats = PracticeStats.initial

        stats.recordAnswer(correct: true, difficulty: .easy)
        stats.recordAnswer(correct: true, difficulty: .easy)
        stats.recordAnswer(correct: true, difficulty: .easy)
        stats.recordAnswer(correct: false, difficulty: .easy)

        XCTAssertEqual(stats.totalAttempted, 4)
        XCTAssertEqual(stats.correct, 3)
        XCTAssertEqual(stats.accuracy, 0.75, accuracy: 0.001)
    }

    func testCodable() throws {
        var stats = PracticeStats.initial
        stats.recordAnswer(correct: true, difficulty: .easy)
        stats.recordAnswer(correct: true, difficulty: .medium)
        stats.recordAnswer(correct: false, difficulty: .hard)

        // Encode
        let encoder = JSONEncoder()
        let data = try encoder.encode(stats)

        // Decode
        let decoder = JSONDecoder()
        let decodedStats = try decoder.decode(PracticeStats.self, from: data)

        XCTAssertEqual(stats, decodedStats)
        XCTAssertEqual(decodedStats.totalAttempted, 3)
        XCTAssertEqual(decodedStats.correct, 2)
        XCTAssertEqual(decodedStats.currentStreak, 0)
    }
}
