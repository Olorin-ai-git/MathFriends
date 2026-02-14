//
//  PracticeSessionViewModel.swift
//  MathFriends
//
//  Central ViewModel for practice session state management
//  Equivalent to Zustand store from React app
//

import Foundation
import SwiftUI

/// Feedback state after answer submission
struct Feedback: Equatable {
    let isCorrect: Bool
    let message: String
    let outOfAttempts: Bool

    init(isCorrect: Bool, message: String, outOfAttempts: Bool = false) {
        self.isCorrect = isCorrect
        self.message = message
        self.outOfAttempts = outOfAttempts
    }
}

/// Main ViewModel for practice session
@MainActor
final class PracticeSessionViewModel: ObservableObject {
    // MARK: - Published State

    @Published private(set) var currentProblem: AnyProblem?
    @Published private(set) var stats: PracticeStats
    @Published private(set) var feedback: Feedback?
    @Published private(set) var attemptsRemaining: Int
    @Published var difficulty: Difficulty = .easy
    @Published var showingDifficultySelector: Bool = true
    @Published var isLoading: Bool = false

    // MARK: - Dependencies

    private let problemGenerator: ProblemGenerator
    private let statsRepository: StatsRepository
    private let config: AppConfigurationProtocol

    // MARK: - Initialization

    init(
        problemGenerator: ProblemGenerator = ProblemGenerator(),
        statsRepository: StatsRepository = UserDefaultsStatsRepository(),
        config: AppConfigurationProtocol = AppConfiguration.shared
    ) {
        self.problemGenerator = problemGenerator
        self.statsRepository = statsRepository
        self.config = config
        self.attemptsRemaining = config.maxAttemptsPerProblem

        // Load stats from persistence
        self.stats = statsRepository.load()
    }

    // MARK: - Actions

    /// Select difficulty and start practicing
    func selectDifficulty(_ difficulty: Difficulty) {
        self.difficulty = difficulty
        self.showingDifficultySelector = false
        self.currentProblem = nil
        self.feedback = nil
        self.attemptsRemaining = config.maxAttemptsPerProblem

        // Load first problem
        loadProblem()
    }

    /// Show difficulty selector
    func showDifficultySelector() {
        self.showingDifficultySelector = true
        self.currentProblem = nil
        self.feedback = nil
        self.attemptsRemaining = config.maxAttemptsPerProblem
    }

    /// Load a new problem
    func loadProblem() {
        isLoading = true
        feedback = nil
        attemptsRemaining = config.maxAttemptsPerProblem

        // Generate problem (synchronous operation)
        let problem = problemGenerator.generate(difficulty: difficulty)
        currentProblem = problem
        isLoading = false
    }

    /// Submit an answer
    func submitAnswer(_ userAnswer: Double) {
        guard let problem = currentProblem else { return }

        isLoading = true

        // Validate answer
        let correct = validateAnswer(userAnswer, correctAnswer: problem.answer)

        if correct {
            // Correct answer - update stats and advance
            var newStats = stats
            newStats.recordAnswer(correct: true, difficulty: difficulty)
            statsRepository.save(newStats)

            self.stats = newStats
            self.attemptsRemaining = config.maxAttemptsPerProblem
            self.feedback = Feedback(
                isCorrect: true,
                message: "Great job! That's correct!"
            )
            self.isLoading = false

            // Auto-advance after correct answer
            Task {
                try? await Task.sleep(nanoseconds: UInt64(config.autoAdvanceDelay * 1_000_000_000))
                nextProblem()
            }
        } else {
            let remaining = attemptsRemaining - 1

            if remaining <= 0 {
                // Out of attempts - record as incorrect, show answer, advance
                var newStats = stats
                newStats.recordAnswer(correct: false, difficulty: difficulty)
                statsRepository.save(newStats)

                self.stats = newStats
                self.attemptsRemaining = 0
                self.feedback = Feedback(
                    isCorrect: false,
                    message: formatCorrectAnswer(problem),
                    outOfAttempts: true
                )
                self.isLoading = false

                // Auto-advance after showing answer
                Task {
                    try? await Task.sleep(nanoseconds: UInt64(4.0 * 1_000_000_000))
                    nextProblem()
                }
            } else {
                // Still has attempts - let them try again
                self.attemptsRemaining = remaining
                self.feedback = Feedback(
                    isCorrect: false,
                    message: "Not quite! \(remaining) \(remaining == 1 ? "try" : "tries") remaining"
                )
                self.isLoading = false
            }
        }
    }

    /// Load next problem
    func nextProblem() {
        feedback = nil
        attemptsRemaining = config.maxAttemptsPerProblem
        loadProblem()
    }

    /// Clear feedback (for "Try Again" button)
    func clearFeedback() {
        feedback = nil
    }

    /// Reset all stats
    func resetStats() {
        var newStats = PracticeStats.initial
        statsRepository.save(newStats)
        self.stats = newStats
    }

    // MARK: - Private Methods

    private func validateAnswer(_ userAnswer: Double, correctAnswer: Double) -> Bool {
        let tolerance = 0.001
        return abs(userAnswer - correctAnswer) < tolerance
    }

    private func formatCorrectAnswer(_ problem: AnyProblem) -> String {
        if let systemProblem = problem.asSystemEquationProblem {
            return "The correct answer is x = \(Int(systemProblem.answerX)), y = \(Int(systemProblem.answerY))"
        }
        return "The correct answer is \(Int(problem.answer))"
    }
}
