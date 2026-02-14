//
//  ProblemGenerator.swift
//  MathFriends
//
//  Direct port from TypeScript problem generation logic
//  Generates math problems for all three difficulty levels
//

import Foundation

/// Service for generating math problems
final class ProblemGenerator {
    private let config: AppConfigurationProtocol
    private var rng: RandomNumberGenerator
    private var idGenerator: IDGenerator

    init(
        config: AppConfigurationProtocol = AppConfiguration.shared,
        rng: RandomNumberGenerator = SystemRandomNumberGenerator(),
        idGenerator: IDGenerator = UUIDGenerator()
    ) {
        self.config = config
        self.rng = rng
        self.idGenerator = idGenerator
    }

    /// Generate a problem for the specified difficulty
    func generate(difficulty: Difficulty) -> AnyProblem {
        switch difficulty {
        case .superEasy:
            return AnyProblem(generateSuperEasyProblem())
        case .easy:
            return AnyProblem(generateEasyProblem())
        case .medium:
            return AnyProblem(generateMediumProblem())
        case .hard:
            return AnyProblem(generateHardProblem())
        case .extreme:
            return generateExtremeProblem()
        }
    }

    // MARK: - Super Easy Problems (Simple Addition 0-5)

    private func generateSuperEasyProblem() -> BasicProblem {
        let num1 = rng.nextInt(in: config.superEasyNumberRange)
        let num2 = rng.nextInt(in: config.superEasyNumberRange)
        let answer = Double(num1 + num2)

        return BasicProblem(
            id: idGenerator.generateID(),
            num1: num1,
            num2: num2,
            operation: .addition,
            answer: answer,
            difficulty: .superEasy
        )
    }

    // MARK: - Easy Problems (Addition & Subtraction 0-20)

    private func generateEasyProblem() -> BasicProblem {
        // Randomly choose addition or subtraction
        let operation: Operation = rng.next() > 0.5 ? .addition : .subtraction

        let num1: Int
        let num2: Int
        let answer: Double

        if operation == .addition {
            // Addition: ensure sum ≤ 20
            num1 = rng.nextInt(in: config.easyNumberRange)
            num2 = rng.nextInt(in: 0...(config.easyNumberRange.upperBound - num1))
            answer = Double(num1 + num2)
        } else {
            // Subtraction: ensure no negatives
            num1 = rng.nextInt(in: config.easyNumberRange)
            num2 = rng.nextInt(in: 0...num1)
            answer = Double(num1 - num2)
        }

        return BasicProblem(
            id: idGenerator.generateID(),
            num1: num1,
            num2: num2,
            operation: operation,
            answer: answer,
            difficulty: .easy
        )
    }

    // MARK: - Medium Problems (Multiplication, Division, Powers)

    private func generateMediumProblem() -> BasicProblem {
        let problemTypes: [Operation] = [.multiplication, .division, .power]
        guard let problemType = rng.nextElement(from: problemTypes) else {
            fatalError("Failed to select problem type")
        }

        let num1: Int
        let num2: Int
        let answer: Double

        switch problemType {
        case .multiplication:
            // Multiplication: 0-12 × 0-12
            num1 = rng.nextInt(in: config.mediumMultiplicationRange)
            num2 = rng.nextInt(in: config.mediumMultiplicationRange)
            answer = Double(num1 * num2)

        case .division:
            // Division: Generate quotient first to ensure whole numbers
            num2 = rng.nextInt(in: 1...config.mediumMultiplicationRange.upperBound) // divisor (no division by 0)
            let quotient = rng.nextInt(in: 1...config.mediumMultiplicationRange.upperBound)
            num1 = num2 * quotient // dividend = divisor × quotient
            answer = Double(quotient)

        case .power:
            // Powers: base (2-5), exponent (2-5)
            guard let base = rng.nextElement(from: config.mediumPowerBases) else {
                fatalError("Failed to select power base")
            }
            num1 = base
            num2 = rng.nextInt(in: config.mediumPowerExponentRange)
            answer = pow(Double(num1), Double(num2))

        default:
            fatalError("Unexpected operation type")
        }

        return BasicProblem(
            id: idGenerator.generateID(),
            num1: num1,
            num2: num2,
            operation: problemType,
            answer: answer,
            difficulty: .medium
        )
    }

    // MARK: - Hard Problems (Linear Equations: ax + b = c)

    private func generateHardProblem() -> EquationProblem {
        let x = rng.nextInt(in: config.hardVariableRange)
        let a = rng.nextInt(in: config.hardCoefficientRange)
        let b = rng.nextInt(in: config.hardConstantRange)
        let c = a * x + b

        let bSign = b >= 0 ? "+" : "-"
        let bValue = abs(b)
        let equation = "\(a)x \(bSign) \(bValue) = \(c)"

        return EquationProblem(
            id: idGenerator.generateID(),
            equation: equation,
            answer: Double(x),
            difficulty: .hard
        )
    }

    // MARK: - Extreme Problems (Systems of Equations & Quadratics)

    private func generateExtremeProblem() -> AnyProblem {
        return rng.next() > 0.5
            ? AnyProblem(generateSystemEquationProblem())
            : AnyProblem(generateQuadraticProblem())
    }

    private func generateSystemEquationProblem() -> SystemEquationProblem {
        let x = rng.nextInt(in: config.extremeVariableRange)
        let y = rng.nextInt(in: config.extremeVariableRange)

        var a1 = rng.nextInt(in: 1...6)
        var b1 = rng.nextInt(in: 1...6)
        var a2 = rng.nextInt(in: 1...6)
        var b2 = rng.nextInt(in: 1...6)

        while a1 * b2 - a2 * b1 == 0 {
            b2 = rng.nextInt(in: 1...6)
        }

        if rng.next() > 0.5 { b1 = -b1 }
        if rng.next() > 0.5 { a2 = -a2 }

        let c1 = a1 * x + b1 * y
        let c2 = a2 * x + b2 * y

        let equation1 = "\(formatTerm(a1, "x", true))\(formatTerm(b1, "y", false)) = \(c1)"
        let equation2 = "\(formatTerm(a2, "x", true))\(formatTerm(b2, "y", false)) = \(c2)"

        return SystemEquationProblem(
            id: idGenerator.generateID(),
            equation1: equation1,
            equation2: equation2,
            answerX: Double(x),
            answerY: Double(y),
            difficulty: .extreme
        )
    }

    private func generateQuadraticProblem() -> EquationProblem {
        let r1 = rng.nextInt(in: -8...8)
        let r2 = rng.nextInt(in: -8...8)

        let b = -(r1 + r2)
        let c = r1 * r2
        let answer = min(r1, r2)

        var equation = "x²"
        if b != 0 {
            if b > 0 {
                equation += " + \(b == 1 ? "" : "\(b)")x"
            } else {
                equation += " - \(b == -1 ? "" : "\(abs(b))")x"
            }
        }
        if c != 0 {
            equation += c > 0 ? " + \(c)" : " - \(abs(c))"
        }
        equation += " = 0"

        return EquationProblem(
            id: idGenerator.generateID(),
            equation: equation,
            answer: Double(answer),
            difficulty: .extreme
        )
    }

    // MARK: - Helpers

    private func formatTerm(_ coeff: Int, _ variable: String, _ isFirst: Bool) -> String {
        let absCoeff = abs(coeff)
        let sign = coeff >= 0 ? (isFirst ? "" : " + ") : (isFirst ? "-" : " - ")
        let coeffStr = absCoeff == 1 ? "" : "\(absCoeff)"
        return "\(sign)\(coeffStr)\(variable)"
    }
}
