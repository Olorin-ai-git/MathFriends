# Xcode Project Setup Guide

## Creating the Xcode Project

Since the Swift source files have been generated, you need to create an Xcode project to build and run the app. Follow these steps:

### Step 1: Create New Xcode Project

1. Open Xcode
2. Select **File → New → Project**
3. Choose **iOS → App**
4. Configure the project:
   - **Product Name**: `MathFriends`
   - **Team**: Select your development team (or None for Simulator-only)
   - **Organization Identifier**: `com.mathfriends`
   - **Bundle Identifier**: `com.mathfriends.app`
   - **Interface**: **SwiftUI**
   - **Language**: **Swift**
   - **Storage**: None (we use UserDefaults)
   - **Include Tests**: ✅ Yes
5. Save the project in: `/Users/olorin/Documents/Projects/MathFriends/ios/`

### Step 2: Add Source Files to Project

1. **Delete** the default `ContentView.swift` file created by Xcode
2. In Xcode's Project Navigator, right-click on the `MathFriends` folder
3. Select **Add Files to "MathFriends"...**
4. Navigate to `/Users/olorin/Documents/Projects/MathFriends/ios/MathFriends/MathFriends/`
5. Select **all folders** (Configuration, Models, ViewModels, Views, Services, Utilities)
6. Ensure these options are selected:
   - ✅ **Copy items if needed** (only if files are outside project directory)
   - ✅ **Create groups** (not folder references)
   - ✅ **Add to targets: MathFriends**
7. Click **Add**

### Step 3: Replace Info.plist (if needed)

1. Locate the existing `Info.plist` in Xcode
2. Replace its contents with the generated `Info.plist` from:
   `/Users/olorin/Documents/Projects/MathFriends/ios/MathFriends/MathFriends/Info.plist`

### Step 4: Configure Build Settings

1. Select the **MathFriends project** in Project Navigator
2. Select the **MathFriends target**
3. Go to **General** tab:
   - **Minimum Deployments**: `iOS 16.0`
   - **Display Name**: `MathFriends`
   - **Bundle Identifier**: `com.mathfriends.app`
   - **Version**: `1.0`
   - **Build**: `1`

4. Go to **Signing & Capabilities** tab:
   - Select your **Team** (for running on device)
   - Or use **Signing Certificate: Sign to Run Locally** (for Simulator only)

### Step 5: Verify File Structure in Xcode

Your Project Navigator should look like this:

```
MathFriends
├── MathFriendsApp.swift
├── Configuration/
│   └── AppConfiguration.swift
├── Models/
│   ├── Difficulty.swift
│   ├── Operation.swift
│   ├── Problem.swift
│   └── PracticeStats.swift
├── ViewModels/
│   └── PracticeSessionViewModel.swift
├── Views/
│   ├── DifficultySelectionView.swift
│   ├── PracticeView.swift
│   └── Components/
│       ├── DifficultyCardView.swift
│       ├── StatCardView.swift
│       ├── FeedbackBannerView.swift
│       └── ProblemDisplayView.swift
├── Services/
│   ├── ProblemGenerator.swift
│   └── Repositories/
│       └── StatsRepository.swift
├── Utilities/
│   ├── RandomHelpers.swift
│   └── IDGenerator.swift
├── Resources/
│   └── Assets.xcassets/
└── Info.plist
```

### Step 6: Build the Project

1. Select a simulator (e.g., **iPhone 15** or **iPhone 15 Pro Max**)
2. Press **Cmd+B** to build
3. Fix any import or configuration issues that appear
4. Once build succeeds, press **Cmd+R** to run

## Troubleshooting

### Common Issues

#### Issue: "Cannot find type 'X' in scope"
**Solution**: Ensure all files are added to the target. Check:
1. Select the file in Project Navigator
2. Open **File Inspector** (right panel)
3. Verify **Target Membership** includes `MathFriends`

#### Issue: "Duplicate symbols" or "Redefinition"
**Solution**:
1. Check that files aren't added multiple times
2. In Project Navigator, select `MathFriends` target → **Build Phases**
3. Check **Compile Sources** section for duplicates
4. Remove duplicate entries

#### Issue: "@main attribute cannot be used"
**Solution**: Ensure only `MathFriendsApp.swift` has `@main` attribute. Remove any other files with `@main`.

#### Issue: Build succeeds but app crashes on launch
**Solution**:
1. Check Console output in Xcode for error messages
2. Verify `Info.plist` is properly configured
3. Ensure minimum iOS version is 16.0+

### Simulator Testing

Recommended simulators for testing:
- **iPhone SE (3rd gen)** - Smallest screen
- **iPhone 15** - Standard size
- **iPhone 15 Pro Max** - Largest phone
- **iPad (10th gen)** - Tablet layout

Test all orientations:
- Portrait
- Landscape Left
- Landscape Right

## Next Steps

After successful build:

1. **Run Unit Tests**: Press `Cmd+U`
2. **Test All Difficulty Levels**:
   - Select Easy → Solve 10 problems
   - Select Medium → Solve 10 problems
   - Select Hard → Solve 10 problems
3. **Test Stats Persistence**:
   - Solve some problems
   - Close app (Cmd+Q on simulator)
   - Relaunch app
   - Verify stats are preserved
4. **Test Auto-Advance**: Answer correctly and wait 2.5 seconds
5. **Test "Try Again"**: Answer incorrectly and tap "Try Again"
6. **Test Difficulty Switching**: Tap "Change Level" mid-session

## Adding Tests

### Create Test Target (if not already created)

1. Select **File → New → Target**
2. Choose **iOS → Unit Testing Bundle**
3. Name it `MathFriendsTests`
4. Add test files in `MathFriendsTests/` folder

### Example Test File Structure

```
MathFriendsTests/
├── ModelTests/
│   ├── ProblemTests.swift
│   ├── DifficultyTests.swift
│   └── StatsTests.swift
├── ViewModelTests/
│   └── PracticeSessionViewModelTests.swift
├── ServiceTests/
│   └── ProblemGeneratorTests.swift
└── RepositoryTests/
    └── StatsRepositoryTests.swift
```

## Preparing for App Store

When ready for production:

1. **Configure Signing**:
   - Add your Apple Developer account to Xcode
   - Select your team in Signing settings
   - Ensure provisioning profile is valid

2. **Create Archive**:
   - Select **Any iOS Device** as destination
   - Choose **Product → Archive**
   - Upload to App Store Connect

3. **App Store Assets**:
   - App Icon (1024x1024px)
   - Screenshots for all device sizes
   - App preview video (optional)
   - App description and keywords

4. **Privacy Policy**:
   - Since app doesn't collect data: "No Data Collected"
   - Update privacy nutrition label accordingly

## Support

If you encounter issues not covered here:
1. Check Xcode console for detailed error messages
2. Verify all dependencies are correctly linked
3. Clean build folder: **Shift+Cmd+K**
4. Delete derived data: **Xcode → Preferences → Locations → Derived Data → Delete**
5. Restart Xcode
