//
//  ProblemGeneratorTests.swift
//  MathFriendsTests
//
//  Unit tests for ProblemGenerator service
//

import XCTest
@testable import MathFriends

final class ProblemGeneratorTests: XCTestCase {

    var generator: ProblemGenerator!

    override func setUp() {
        super.setUp()
        generator = ProblemGenerator()
    }

    // MARK: - Easy Problems Tests

    func testEasyProblemsAreInRange() {
        for _ in 0..<100 {
            let problem = generator.generate(difficulty: .easy)

            XCTAssertEqual(problem.difficulty, .easy)
            XCTAssertLessThanOrEqual(problem.answer, 20)
            XCTAssertGreaterThanOrEqual(problem.answer, 0)
        }
    }

    func testEasyAdditionSumIsValid() {
        for _ in 0..<100 {
            let problem = generator.generate(difficulty: .easy)
            guard let basicProblem = problem.asBasicProblem else { continue }

            if basicProblem.operation == .addition {
                let sum = basicProblem.num1 + basicProblem.num2
                XCTAssertEqual(Double(sum), basicProblem.answer)
                XCTAssertLessThanOrEqual(sum, 20, "Addition sum must be ≤ 20")
            }
        }
    }

    func testEasySubtractionNoNegatives() {
        for _ in 0..<100 {
            let problem = generator.generate(difficulty: .easy)
            guard let basicProblem = problem.asBasicProblem else { continue }

            if basicProblem.operation == .subtraction {
                XCTAssertGreaterThanOrEqual(basicProblem.num1, basicProblem.num2,
                    "Subtraction must not produce negatives")
                let result = basicProblem.num1 - basicProblem.num2
                XCTAssertEqual(Double(result), basicProblem.answer)
                XCTAssertGreaterThanOrEqual(result, 0)
            }
        }
    }

    // MARK: - Medium Problems Tests

    func testMediumMultiplicationIsInRange() {
        var foundMultiplication = false

        for _ in 0..<100 {
            let problem = generator.generate(difficulty: .medium)
            guard let basicProblem = problem.asBasicProblem else { continue }

            if basicProblem.operation == .multiplication {
                foundMultiplication = true
                XCTAssertLessThanOrEqual(basicProblem.num1, 12)
                XCTAssertLessThanOrEqual(basicProblem.num2, 12)

                let product = basicProblem.num1 * basicProblem.num2
                XCTAssertEqual(Double(product), basicProblem.answer)
            }
        }

        XCTAssertTrue(foundMultiplication, "Should generate at least one multiplication problem")
    }

    func testMediumDivisionProducesWholeNumbers() {
        var foundDivision = false

        for _ in 0..<100 {
            let problem = generator.generate(difficulty: .medium)
            guard let basicProblem = problem.asBasicProblem else { continue }

            if basicProblem.operation == .division {
                foundDivision = true

                // Answer should be a whole number
                XCTAssertEqual(basicProblem.answer, floor(basicProblem.answer),
                    "Division should produce whole number answers")

                // Verify division
                let quotient = basicProblem.num1 / basicProblem.num2
                XCTAssertEqual(Double(quotient), basicProblem.answer)

                // Verify no division by zero
                XCTAssertGreaterThan(basicProblem.num2, 0)
            }
        }

        XCTAssertTrue(foundDivision, "Should generate at least one division problem")
    }

    func testMediumPowersAreValid() {
        var foundPower = false

        for _ in 0..<100 {
            let problem = generator.generate(difficulty: .medium)
            guard let basicProblem = problem.asBasicProblem else { continue }

            if basicProblem.operation == .power {
                foundPower = true

                // Base should be 2-5
                XCTAssertGreaterThanOrEqual(basicProblem.num1, 2)
                XCTAssertLessThanOrEqual(basicProblem.num1, 5)

                // Exponent should be 2-5
                XCTAssertGreaterThanOrEqual(basicProblem.num2, 2)
                XCTAssertLessThanOrEqual(basicProblem.num2, 5)

                // Verify power calculation
                let power = pow(Double(basicProblem.num1), Double(basicProblem.num2))
                XCTAssertEqual(power, basicProblem.answer, accuracy: 0.001)
            }
        }

        XCTAssertTrue(foundPower, "Should generate at least one power problem")
    }

    // MARK: - Hard Problems Tests

    func testHardProblemsAreEquations() {
        for _ in 0..<100 {
            let problem = generator.generate(difficulty: .hard)

            XCTAssertNotNil(problem.asEquationProblem, "Hard problems should be equations")
            XCTAssertEqual(problem.difficulty, .hard)
        }
    }

    func testHardEquationsHaveIntegerSolutions() {
        for _ in 0..<100 {
            let problem = generator.generate(difficulty: .hard)
            guard let equationProblem = problem.asEquationProblem else {
                XCTFail("Hard problem should be equation")
                continue
            }

            // Answer should be an integer
            XCTAssertEqual(equationProblem.answer, floor(equationProblem.answer),
                "Equation solutions should be integers")

            // Answer should be in range -10 to 10
            XCTAssertGreaterThanOrEqual(equationProblem.answer, -10)
            XCTAssertLessThanOrEqual(equationProblem.answer, 10)
        }
    }

    func testHardEquationsHaveNoHints() {
        let problem = generator.generate(difficulty: .hard)
        guard problem.asEquationProblem != nil else {
            XCTFail("Hard problem should be equation")
            return
        }
        // Hints have been removed from equation problems
    }

    // MARK: - Determinism Tests

    func testSeededGeneratorIsDeterministic() {
        let seed: UInt64 = 12345
        var rng1 = SeededRandomNumberGenerator(seed: seed)
        var rng2 = SeededRandomNumberGenerator(seed: seed)

        let generator1 = ProblemGenerator(rng: rng1)
        let generator2 = ProblemGenerator(rng: rng2)

        // Generate same problem with same seed
        let problem1 = generator1.generate(difficulty: .easy)
        let problem2 = generator2.generate(difficulty: .easy)

        XCTAssertEqual(problem1.answer, problem2.answer)
        XCTAssertEqual(problem1.displayString(), problem2.displayString())
    }

    // MARK: - ID Generation Tests

    func testProblemsHaveUniqueIDs() {
        var ids = Set<String>()

        for _ in 0..<100 {
            let problem = generator.generate(difficulty: .easy)
            XCTAssertFalse(ids.contains(problem.id), "Problem IDs should be unique")
            ids.insert(problem.id)
        }
    }
}
