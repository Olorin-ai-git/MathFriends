//
//  StatsRepository.swift
//  MathFriends
//
//  Stats persistence layer
//

import Foundation

/// Protocol for stats persistence
protocol StatsRepository {
    func load() -> PracticeStats
    func save(_ stats: PracticeStats)
    func reset()
}

/// UserDefaults-based stats repository (production implementation)
final class UserDefaultsStatsRepository: StatsRepository {
    private let key: String
    private let defaults: UserDefaults

    init(
        key: String = "mathfriends.stats",
        defaults: UserDefaults = .standard
    ) {
        self.key = key
        self.defaults = defaults
    }

    func load() -> PracticeStats {
        guard let data = defaults.data(forKey: key) else {
            return .initial
        }

        do {
            let stats = try JSONDecoder().decode(PracticeStats.self, from: data)
            return stats
        } catch {
            // If decoding fails, return initial stats
            return .initial
        }
    }

    func save(_ stats: PracticeStats) {
        do {
            let data = try JSONEncoder().encode(stats)
            defaults.set(data, forKey: key)
        } catch {
            // Encoding should never fail for our simple struct
            assertionFailure("Failed to encode PracticeStats: \(error)")
        }
    }

    func reset() {
        defaults.removeObject(forKey: key)
    }
}
