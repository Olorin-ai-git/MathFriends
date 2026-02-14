//
//  Difficulty.swift
//  MathFriends
//
//  Native iOS implementation - Swift port from TypeScript
//

import Foundation

/// Represents the difficulty level of math problems
enum Difficulty: String, Codable, CaseIterable, Identifiable {
    case superEasy
    case easy
    case medium
    case hard
    case extreme

    var id: String { rawValue }

    /// Display name for UI
    var displayName: String {
        switch self {
        case .superEasy: return "Super Easy"
        case .easy: return "Easy"
        case .medium: return "Medium"
        case .hard: return "Hard"
        case .extreme: return "Extreme"
        }
    }

    /// Emoji indicator for UI
    var emoji: String {
        switch self {
        case .superEasy: return "🧸"
        case .easy: return "🌟"
        case .medium: return "⭐"
        case .hard: return "🚀"
        case .extreme: return "🔥"
        }
    }

    /// Description of problem types
    var description: String {
        switch self {
        case .superEasy: return "Simple Addition (0-5)"
        case .easy: return "Addition & Subtraction"
        case .medium: return "Multiplication, Division & Powers"
        case .hard: return "Simple Equations"
        case .extreme: return "Quadratics & Systems of Equations"
        }
    }

    /// Color for UI representation
    var colorName: String {
        switch self {
        case .superEasy: return "yellow"
        case .easy: return "green"
        case .medium: return "blue"
        case .hard: return "purple"
        case .extreme: return "red"
        }
    }
}
