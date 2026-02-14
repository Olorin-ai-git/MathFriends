//
//  Operation.swift
//  MathFriends
//
//  Native iOS implementation - Swift port from TypeScript
//

import Foundation

/// Represents mathematical operations
enum Operation: String, Codable {
    case addition = "+"
    case subtraction = "-"
    case multiplication = "*"
    case division = "/"
    case power = "^"

    /// Display symbol for UI
    var symbol: String {
        return rawValue
    }
}
