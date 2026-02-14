# MathFriends - Native iOS App

Native iOS Swift/SwiftUI implementation of Math Friends, a math practice app for children.

## Overview

This is a production-ready native iOS application that provides identical functionality to the web version:
- Three difficulty levels (Easy, Medium, Hard)
- Real-time problem generation
- Statistics tracking with streaks
- Offline-first architecture
- Native SwiftUI interface

## Requirements

- **iOS**: 16.0+
- **Xcode**: 15.0+
- **Swift**: 5.9+
- **Deployment Target**: iOS 16.0

## Architecture

```
┌─────────────────────────────────────────────────┐
│                  SwiftUI Views                   │
│  (DifficultySelectionView, PracticeView, etc.)  │
└─────────────────┬───────────────────────────────┘
                  │ @ObservedObject
                  ▼
┌─────────────────────────────────────────────────┐
│              ViewModels                          │
│  (PracticeSessionViewModel - @Published state)  │
└─────────────────┬───────────────────────────────┘
                  │ Uses
                  ▼
┌─────────────────────────────────────────────────┐
│         Services & Repositories                  │
│  • ProblemGenerator (port of TS logic)          │
│  • StatsRepository (UserDefaults persistence)   │
└─────────────────────────────────────────────────┘
```

### Key Components

**Models** (`Models/`):
- `Difficulty.swift` - Difficulty levels enum
- `Operation.swift` - Math operations enum
- `Problem.swift` - Problem protocol and implementations
- `PracticeStats.swift` - Statistics tracking model

**Services** (`Services/`):
- `ProblemGenerator.swift` - Problem generation logic (direct TypeScript port)
- `Repositories/StatsRepository.swift` - Stats persistence layer

**ViewModels** (`ViewModels/`):
- `PracticeSessionViewModel.swift` - Central state management (equivalent to Zustand store)

**Views** (`Views/`):
- `DifficultySelectionView.swift` - Difficulty selection screen
- `PracticeView.swift` - Main practice interface
- `Components/` - Reusable UI components

**Configuration** (`Configuration/`):
- `AppConfiguration.swift` - Centralized configuration (no hardcoded values)

**Utilities** (`Utilities/`):
- `RandomHelpers.swift` - Random number generation (testable)
- `IDGenerator.swift` - Unique ID generation (testable)

## Project Structure

```
ios/MathFriends/
├── MathFriends/
│   ├── MathFriendsApp.swift         # App entry point
│   ├── Configuration/
│   │   └── AppConfiguration.swift   # Config values
│   ├── Models/
│   │   ├── Difficulty.swift
│   │   ├── Operation.swift
│   │   ├── Problem.swift
│   │   └── PracticeStats.swift
│   ├── ViewModels/
│   │   └── PracticeSessionViewModel.swift
│   ├── Views/
│   │   ├── DifficultySelectionView.swift
│   │   ├── PracticeView.swift
│   │   └── Components/
│   │       ├── DifficultyCardView.swift
│   │       ├── StatCardView.swift
│   │       ├── FeedbackBannerView.swift
│   │       └── ProblemDisplayView.swift
│   ├── Services/
│   │   ├── ProblemGenerator.swift
│   │   └── Repositories/
│   │       └── StatsRepository.swift
│   ├── Utilities/
│   │   ├── RandomHelpers.swift
│   │   └── IDGenerator.swift
│   └── Resources/
│       └── Assets.xcassets/
└── MathFriendsTests/
```

## Problem Generation Logic

### Easy Problems (Addition & Subtraction 0-20)
- **Addition**: num1 (0-20), num2 (0 to 20-num1) → sum ≤ 20
- **Subtraction**: num1 (0-20), num2 (0 to num1) → no negatives

### Medium Problems (Multiplication, Division, Powers)
- **Multiplication**: 0-12 × 0-12
- **Division**: Generate quotient first → dividend = divisor × quotient (whole numbers only)
- **Powers**: base (2-5), exponent (2-5)

### Hard Problems (Linear Equations)
- Format: ax + b = c, solve for x
- Generate x (-10 to 10), a (1-10), b (-20 to 20)
- Calculate c = ax + b
- Include 3-step hints

## Data Persistence

### Stats Storage
- Uses `UserDefaults` for stats persistence
- JSON encoding/decoding via `Codable`
- Synchronous access (instant load/save)
- Key: `"mathfriends.stats"`

### Data Model
```swift
struct PracticeStats: Codable {
    var totalAttempted: Int
    var correct: Int
    var currentStreak: Int
    var bestStreak: Int
    var difficultyStats: [Difficulty: DifficultyStats]
}
```

## Building the App

### Option 1: Open in Xcode (Recommended)

1. Open `ios/MathFriends.xcodeproj` in Xcode
2. Select a simulator or device target
3. Press `Cmd+R` to build and run

### Option 2: Command Line

```bash
cd ios/MathFriends
xcodebuild -scheme MathFriends -destination 'platform=iOS Simulator,name=iPhone 15' build
```

## Running Tests

```bash
cd ios/MathFriends
xcodebuild test -scheme MathFriends -destination 'platform=iOS Simulator,name=iPhone 15'
```

Or in Xcode: `Cmd+U`

## Configuration

All configuration values are centralized in `AppConfiguration.swift`:

```swift
// Problem generation ranges
easyNumberRange: 0...20
mediumMultiplicationRange: 0...12
mediumPowerBases: [2, 3, 4, 5]
hardVariableRange: -10...10

// UI configuration
autoAdvanceDelay: 2.5 seconds
```

To customize, extend `AppConfiguration` to read from `Info.plist` or environment variables.

## Features

### ✅ Implemented
- Three difficulty levels with appropriate problem types
- Real-time problem generation (client-side)
- Statistics tracking (attempted, correct, streaks)
- Persistent stats across app launches
- Auto-advance after correct answer (2.5s delay)
- "Try Again" button for incorrect answers
- Difficulty switching mid-session
- Hints for hard problems (expandable)
- Accuracy percentage display
- Native iOS design matching web aesthetics

### 🚧 Future Enhancements
- Home screen widgets (small, medium, large)
- App Groups for widget data sharing
- Deep linking (`mathfriends://`)
- iOS 17+ interactive widgets
- Dark mode support
- Haptic feedback
- Sound effects
- iCloud sync
- Achievement system

## Testing Strategy

### Unit Tests
- Model tests (Problem, Stats)
- ProblemGenerator tests (range constraints, determinism)
- ViewModel tests (state management)
- Repository tests (persistence)

### UI Tests
- Full user flow (select difficulty → solve problem → view feedback)
- Stats updates
- Auto-advance behavior
- Error states

### Manual Testing Checklist
- [ ] All three difficulty levels generate valid problems
- [ ] Stats persist across app restarts
- [ ] Streak increments/resets correctly
- [ ] Auto-advance works after correct answer
- [ ] "Try Again" works for incorrect answers
- [ ] Hints expand/collapse on hard problems
- [ ] Number keyboard appears for input
- [ ] UI scales on iPhone SE through iPad

## Performance Targets

- App launch: < 1 second
- Problem generation: < 10ms
- Answer submission: < 100ms
- Memory usage: < 50MB
- No memory leaks

## Design Guidelines

### Colors
- Background: Linear gradient (blue-50 to indigo-100)
- Cards: White with subtle shadow
- Stats colors: Green (correct), Blue (streak), Purple (best)

### Typography
- Title: 48pt bold
- Problem: 48pt bold
- Stats: 24pt bold
- Labels: 12-14pt regular

### Spacing
- Card padding: 16-24pt
- Section spacing: 24-32pt
- Component spacing: 12-16pt

## License

Copyright © 2026 MathFriends. All rights reserved.

## Support

For issues or questions, please contact support@mathfriends.com
