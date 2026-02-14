//
//  RandomHelpers.swift
//  MathFriends
//
//  Random number generation utilities
//

import Foundation

/// Protocol for random number generation (enables testing with seeded generator)
protocol RandomNumberGenerator {
    mutating func next() -> Double
    mutating func nextInt(in range: ClosedRange<Int>) -> Int
    mutating func nextElement<T>(from array: [T]) -> T?
}

/// System random number generator (default production implementation)
struct SystemRandomNumberGenerator: RandomNumberGenerator {
    func next() -> Double {
        return Double.random(in: 0..<1)
    }

    func nextInt(in range: ClosedRange<Int>) -> Int {
        return Int.random(in: range)
    }

    func nextElement<T>(from array: [T]) -> T? {
        guard !array.isEmpty else { return nil }
        return array.randomElement()
    }
}

/// Seeded random number generator for deterministic testing
struct SeededRandomNumberGenerator: RandomNumberGenerator {
    private var state: UInt64

    init(seed: UInt64) {
        self.state = seed
    }

    mutating func next() -> Double {
        // Linear congruential generator (LCG)
        // Values from Numerical Recipes
        let a: UInt64 = 1664525
        let c: UInt64 = 1013904223
        let m: UInt64 = UInt64(1) << 32

        state = (a &* state &+ c) % m
        return Double(state) / Double(m)
    }

    mutating func nextInt(in range: ClosedRange<Int>) -> Int {
        let rangeSize = range.upperBound - range.lowerBound + 1
        let randomValue = Int(next() * Double(rangeSize))
        return range.lowerBound + randomValue
    }

    mutating func nextElement<T>(from array: [T]) -> T? {
        guard !array.isEmpty else { return nil }
        let index = nextInt(in: 0...(array.count - 1))
        return array[index]
    }
}
