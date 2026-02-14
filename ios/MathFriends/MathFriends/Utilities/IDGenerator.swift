//
//  IDGenerator.swift
//  MathFriends
//
//  Unique ID generation
//

import Foundation

/// Protocol for generating unique IDs (enables testing)
protocol IDGenerator {
    mutating func generateID() -> String
}

/// UUID-based ID generator (default production implementation)
struct UUIDGenerator: IDGenerator {
    func generateID() -> String {
        return UUID().uuidString
    }
}

/// Deterministic ID generator for testing
struct DeterministicIDGenerator: IDGenerator {
    private var counter: Int = 0

    mutating func generateID() -> String {
        counter += 1
        return "test-id-\(counter)"
    }
}
