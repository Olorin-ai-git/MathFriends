//
//  AppConfiguration.swift
//  MathFriends
//
//  Configuration values - NO hardcoded values in application code
//

import Foundation

/// Application configuration protocol
protocol AppConfigurationProtocol {
    // Problem generation ranges
    var superEasyNumberRange: ClosedRange<Int> { get }
    var easyNumberRange: ClosedRange<Int> { get }
    var mediumMultiplicationRange: ClosedRange<Int> { get }
    var mediumPowerBases: [Int] { get }
    var mediumPowerExponentRange: ClosedRange<Int> { get }
    var hardVariableRange: ClosedRange<Int> { get }
    var hardCoefficientRange: ClosedRange<Int> { get }
    var hardConstantRange: ClosedRange<Int> { get }
    var extremeVariableRange: ClosedRange<Int> { get }
    var extremeCoefficientRange: ClosedRange<Int> { get }
    var extremeConstantRange: ClosedRange<Int> { get }

    // UI configuration
    var autoAdvanceDelay: TimeInterval { get }
    var maxAttemptsPerProblem: Int { get }
}

/// Default configuration implementation
struct AppConfiguration: AppConfigurationProtocol {
    static let shared: AppConfiguration = AppConfiguration()

    // Problem generation ranges (from defaults, can be overridden by plist)
    let superEasyNumberRange: ClosedRange<Int>
    let easyNumberRange: ClosedRange<Int>
    let mediumMultiplicationRange: ClosedRange<Int>
    let mediumPowerBases: [Int]
    let mediumPowerExponentRange: ClosedRange<Int>
    let hardVariableRange: ClosedRange<Int>
    let hardCoefficientRange: ClosedRange<Int>
    let hardConstantRange: ClosedRange<Int>
    let extremeVariableRange: ClosedRange<Int>
    let extremeCoefficientRange: ClosedRange<Int>
    let extremeConstantRange: ClosedRange<Int>

    // UI configuration
    let autoAdvanceDelay: TimeInterval
    let maxAttemptsPerProblem: Int

    private init() {
        // Load from Info.plist if available, otherwise use defaults
        let bundle = Bundle.main
        let infoDictionary = bundle.infoDictionary

        self.superEasyNumberRange = 0...5
        self.easyNumberRange = 0...20
        self.mediumMultiplicationRange = 0...12
        self.mediumPowerBases = [2, 3, 4, 5]
        self.mediumPowerExponentRange = 2...5
        self.hardVariableRange = -10...10
        self.hardCoefficientRange = 1...10
        self.hardConstantRange = -20...20
        self.extremeVariableRange = -15...15
        self.extremeCoefficientRange = 2...12
        self.extremeConstantRange = -25...25
        self.autoAdvanceDelay = 2.5 // 2.5 seconds
        self.maxAttemptsPerProblem = 5

        // Future: Can extend to read from Info.plist
        // Example:
        // if let plistValue = infoDictionary?["EasyNumberRangeMax"] as? Int {
        //     self.easyNumberRange = 0...plistValue
        // }
    }
}
