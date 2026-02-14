//
//  Problem.swift
//  MathFriends
//
//  Native iOS implementation - Swift port from TypeScript
//

import Foundation

/// Protocol defining a math problem
protocol Problem: Identifiable, Codable {
    var id: String { get }
    var answer: Double { get }
    var difficulty: Difficulty { get }

    /// Display string for the problem
    func displayString() -> String
}

/// Basic arithmetic problem (Easy and Medium difficulties)
struct BasicProblem: Problem {
    let id: String
    let num1: Int
    let num2: Int
    let operation: Operation
    let answer: Double
    let difficulty: Difficulty

    func displayString() -> String {
        switch operation {
        case .power:
            return "\(num1)^\(num2) = ?"
        default:
            return "\(num1) \(operation.symbol) \(num2) = ?"
        }
    }
}

/// Equation problem (Hard and Extreme quadratic difficulties)
struct EquationProblem: Problem {
    let id: String
    let equation: String
    let answer: Double
    let difficulty: Difficulty

    func displayString() -> String {
        return equation
    }
}

/// System of two equations problem (Extreme difficulty)
struct SystemEquationProblem: Problem {
    let id: String
    let equation1: String
    let equation2: String
    let answerX: Double
    let answerY: Double
    let difficulty: Difficulty

    var answer: Double { answerX }

    func displayString() -> String {
        return "\(equation1)\n\(equation2)"
    }
}

/// Type-erased problem wrapper for working with protocols
struct AnyProblem: Problem {
    private let _id: () -> String
    private let _answer: () -> Double
    private let _difficulty: () -> Difficulty
    private let _displayString: () -> String
    private let _problem: Any

    let id: String
    let answer: Double
    let difficulty: Difficulty

    init<P: Problem>(_ problem: P) {
        self._problem = problem
        self.id = problem.id
        self.answer = problem.answer
        self.difficulty = problem.difficulty

        self._id = { problem.id }
        self._answer = { problem.answer }
        self._difficulty = { problem.difficulty }
        self._displayString = { problem.displayString() }
    }

    func displayString() -> String {
        _displayString()
    }

    // Check underlying type
    var isBasicProblem: Bool {
        _problem is BasicProblem
    }

    var asBasicProblem: BasicProblem? {
        _problem as? BasicProblem
    }

    var asEquationProblem: EquationProblem? {
        _problem as? EquationProblem
    }

    var asSystemEquationProblem: SystemEquationProblem? {
        _problem as? SystemEquationProblem
    }

    var isSystemEquation: Bool {
        _problem is SystemEquationProblem
    }
}

// MARK: - Codable conformance for AnyProblem
extension AnyProblem {
    enum CodingKeys: String, CodingKey {
        case type
        case basic
        case equation
        case systemEquation
    }

    enum ProblemType: String, Codable {
        case basic
        case equation
        case systemEquation
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        if let basicProblem = asBasicProblem {
            try container.encode(ProblemType.basic, forKey: .type)
            try container.encode(basicProblem, forKey: .basic)
        } else if let equationProblem = asEquationProblem {
            try container.encode(ProblemType.equation, forKey: .type)
            try container.encode(equationProblem, forKey: .equation)
        } else if let systemProblem = asSystemEquationProblem {
            try container.encode(ProblemType.systemEquation, forKey: .type)
            try container.encode(systemProblem, forKey: .systemEquation)
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(ProblemType.self, forKey: .type)

        switch type {
        case .basic:
            let problem = try container.decode(BasicProblem.self, forKey: .basic)
            self.init(problem)
        case .equation:
            let problem = try container.decode(EquationProblem.self, forKey: .equation)
            self.init(problem)
        case .systemEquation:
            let problem = try container.decode(SystemEquationProblem.self, forKey: .systemEquation)
            self.init(problem)
        }
    }
}
