//
//  PracticeStats.swift
//  MathFriends
//
//  Native iOS implementation - Swift port from TypeScript
//

import Foundation

/// Statistics for a specific difficulty level
struct DifficultyStats: Codable, Equatable {
    var attempted: Int
    var correct: Int

    var accuracy: Double {
        guard attempted > 0 else { return 0 }
        return Double(correct) / Double(attempted)
    }

    static var initial: DifficultyStats {
        DifficultyStats(attempted: 0, correct: 0)
    }
}

/// Overall practice session statistics
struct PracticeStats: Codable, Equatable {
    var totalAttempted: Int
    var correct: Int
    var currentStreak: Int
    var bestStreak: Int
    var difficultyStats: [Difficulty: DifficultyStats]

    /// Overall accuracy percentage
    var accuracy: Double {
        guard totalAttempted > 0 else { return 0 }
        return Double(correct) / Double(totalAttempted)
    }

    /// Initial empty stats
    static var initial: PracticeStats {
        PracticeStats(
            totalAttempted: 0,
            correct: 0,
            currentStreak: 0,
            bestStreak: 0,
            difficultyStats: [
                .superEasy: .initial,
                .easy: .initial,
                .medium: .initial,
                .hard: .initial,
                .extreme: .initial
            ]
        )
    }

    /// Record an answer attempt
    mutating func recordAnswer(correct isCorrect: Bool, difficulty: Difficulty) {
        totalAttempted += 1

        // Update difficulty-specific stats
        var diffStats = difficultyStats[difficulty] ?? .initial
        diffStats.attempted += 1

        if isCorrect {
            correct += 1
            currentStreak += 1
            diffStats.correct += 1

            // Update best streak
            if currentStreak > bestStreak {
                bestStreak = currentStreak
            }
        } else {
            // Reset streak on incorrect answer
            currentStreak = 0
        }

        difficultyStats[difficulty] = diffStats
    }

    /// Reset all stats
    mutating func reset() {
        self = .initial
    }
}

// MARK: - Codable conformance for Dictionary with Difficulty keys
extension PracticeStats {
    enum CodingKeys: String, CodingKey {
        case totalAttempted
        case correct
        case currentStreak
        case bestStreak
        case difficultyStats
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        totalAttempted = try container.decode(Int.self, forKey: .totalAttempted)
        correct = try container.decode(Int.self, forKey: .correct)
        currentStreak = try container.decode(Int.self, forKey: .currentStreak)
        bestStreak = try container.decode(Int.self, forKey: .bestStreak)

        let statsDict = try container.decode([String: DifficultyStats].self, forKey: .difficultyStats)
        difficultyStats = Dictionary(uniqueKeysWithValues: statsDict.compactMap { key, value in
            guard let difficulty = Difficulty(rawValue: key) else { return nil }
            return (difficulty, value)
        })
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(totalAttempted, forKey: .totalAttempted)
        try container.encode(correct, forKey: .correct)
        try container.encode(currentStreak, forKey: .currentStreak)
        try container.encode(bestStreak, forKey: .bestStreak)

        let statsDict = Dictionary(uniqueKeysWithValues: difficultyStats.map { key, value in
            (key.rawValue, value)
        })
        try container.encode(statsDict, forKey: .difficultyStats)
    }
}
