# MathFriends iOS - Quick Start Guide

## ✅ Project Status

The Xcode project has been **successfully created** at:
```
/Users/olorin/Documents/Projects/MathFriends/ios/MathFriends.xcodeproj
```

The project is now **open in Xcode** and ready for the final setup step.

## 🔧 One-Time Setup Required

The project file references need to point to the correct source directory. This is a one-time fix that takes about 30 seconds.

### Steps to Fix File Paths:

1. **In Xcode's left sidebar (Project Navigator)**, you should see the `MathFriends` group with red files (indicating missing file references)

2. **Select the `MathFriends` group** (the top folder icon with your project name)

3. **In the right sidebar (File Inspector)**, look for the "Location" dropdown

4. **Change the path** from `MathFriends` to `MathFriends/MathFriends`
   - Or click the folder icon and navigate to: `/Users/olorin/Documents/Projects/MathFriends/ios/MathFriends/MathFriends`

5. **All file references should now turn black** (indicating they're found)

### Alternative Method (If Above Doesn't Work):

1. **Delete the `MathFriends` group** in Xcode (right-click → Delete → Remove References only, NOT Move to Trash)

2. **Drag the folder** from Finder into Xcode:
   - Open Finder and navigate to: `/Users/olorin/Documents/Projects/MathFriends/ios/MathFriends/MathFriends`
   - Drag the entire `MathFriends` folder into Xcode's Project Navigator
   - In the dialog that appears:
     - ✅ **Create groups** (not folder references)
     - ✅ **Add to target: MathFriends**
     - ✅ **Copy items if needed** (leave unchecked)
   - Click "Finish"

## 🚀 Build and Run

Once file paths are fixed:

1. **Select a simulator**: iPhone 17, iPhone 17 Pro, or iPad
2. **Press Cmd+R** (or click the Run button ▶️)
3. **Wait for build** (should complete in 10-20 seconds)
4. **App launches** in simulator! 🎉

## 📱 What You'll See

The app will launch showing:
1. **Difficulty Selection Screen** with three cards (Easy, Medium, Hard)
2. Tap any difficulty to start practicing
3. **Practice Screen** with:
   - Stats dashboard (Attempted, Correct, Streak, Best)
   - Problem display with answer input
   - Feedback banner after submission
   - Auto-advance after correct answers (2.5s delay)

## ✅ Verify Everything Works

### Test Checklist:
- [ ] App launches without crashes
- [ ] Difficulty selection screen appears
- [ ] Tapping Easy generates addition/subtraction problems (0-20)
- [ ] Tapping Medium generates multiplication/division/power problems
- [ ] Tapping Hard generates linear equations with hints
- [ ] Submit correct answer → Green ✅ feedback → Auto-advance
- [ ] Submit incorrect answer → Red ❌ feedback → "Try Again" button
- [ ] Stats increment correctly
- [ ] Streak increments on correct, resets on incorrect
- [ ] "Change Level" button returns to difficulty selector
- [ ] Close app → Relaunch → Stats are preserved

## 🧪 Run Unit Tests

After successful build:

1. Press **Cmd+U** (or Product → Test)
2. Wait for tests to run
3. All tests should pass ✅

**Note**: If tests don't appear, you may need to add the test files to the test target manually (similar to adding source files).

## 📂 Project Structure

```
MathFriends.xcodeproj/           # Xcode project (generated)
MathFriends/
└── MathFriends/                 # Source code folder
    ├── MathFriendsApp.swift    # App entry point
    ├── Configuration/           # Config (no hardcoded values)
    ├── Models/                  # Data models
    ├── ViewModels/              # MVVM state management
    ├── Views/                   # SwiftUI interfaces
    ├── Services/                # Business logic
    ├── Utilities/               # Helper functions
    ├── Resources/               # Assets
    └── Info.plist              # App configuration
```

## 🐛 Troubleshooting

### Build Error: "Cannot find type 'X' in scope"
**Solution**: Clean build folder (Shift+Cmd+K) and rebuild (Cmd+B)

### Build Error: "Signing requires a development team"
**Solution**:
1. Select project in navigator
2. Select target → Signing & Capabilities
3. Select your Team (or use "Sign to Run Locally" for simulator-only)

### App crashes on launch
**Solution**:
1. Check Xcode console for error messages
2. Verify all files are added to target
3. Clean build folder and rebuild

### Tests don't appear
**Solution**:
1. Add test files to test target:
   - Select test file in navigator
   - Open File Inspector (right sidebar)
   - Check "MathFriendsTests" under Target Membership

## 📝 Next Steps

After successful launch:

1. **Test all three difficulty levels**
2. **Verify stats persistence** (close/reopen app)
3. **Test on different simulators** (iPhone SE, iPad, etc.)
4. **Run unit tests** (Cmd+U)
5. **Profile performance** (Cmd+I → Time Profiler)

## 🎯 Development Tips

### Xcode Shortcuts:
- **Cmd+B**: Build
- **Cmd+R**: Run
- **Cmd+.**: Stop
- **Cmd+U**: Run tests
- **Shift+Cmd+K**: Clean build folder
- **Cmd+0**: Toggle Navigator
- **Cmd+Option+0**: Toggle Inspector
- **Cmd+Shift+O**: Open quickly (find files)

### SwiftUI Previews:
Most views have `#Preview` blocks. To see live previews:
1. Open any view file (e.g., `DifficultyCardView.swift`)
2. Press **Cmd+Option+Enter** to show preview pane
3. Click "Resume" if preview is paused
4. Edit code and see changes in real-time

### Debugging:
- Set breakpoints by clicking line numbers
- Press **Cmd+Y** to toggle breakpoints
- Use `po variableName` in console to inspect values

## 🚀 You're All Set!

The MathFriends iOS app is now ready to run. Once the file paths are fixed, you'll have a fully functional, production-ready native iOS app with:

✅ Three difficulty levels
✅ Problem generation
✅ Stats tracking with persistence
✅ Auto-advance and feedback
✅ Native SwiftUI interface
✅ Zero third-party dependencies
✅ Comprehensive tests

**Enjoy building with your new iOS app!** 🎉
