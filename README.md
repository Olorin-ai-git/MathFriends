# MathFriends - K-12 Math Practice App

A fun, interactive math learning app built with React and Node.js. Students can practice math problems across three difficulty levels with instant feedback.

## Features

- 🌟 **Three Difficulty Levels**:
  - **Easy** (1st Grade): Addition & Subtraction (0-20)
  - **Medium** (2nd-4th Grade): Multiplication, Division & Powers
  - **Hard** (5th Grade): Simple Linear Equations

- ✅ **Instant Feedback**: Know immediately if your answer is correct
- 📊 **Progress Tracking**: Track your streaks, accuracy, and stats (saved in browser)
- 🎯 **Encouraging UI**: Beautiful, kid-friendly interface with emojis and colors
- 📱 **Mobile Friendly**: Responsive design works on all devices
- 💾 **No Login Required**: Start practicing immediately

## Tech Stack

- **Frontend**: React 18 + TypeScript + Vite + Tailwind CSS
- **State Management**: Zustand (client-side)
- **Storage**: Browser localStorage for progress and all data
- **Backend**: None - 100% client-side

## Getting Started

### Prerequisites

- Node.js 18+ installed
- npm or yarn

### Installation

1. Navigate to the project directory:
```bash
cd MathFriends
```

2. Install dependencies for all workspaces:
```bash
npm install
```

### Running the App

#### Development Mode

```bash
npm run dev
```

This starts the Vite development server on `http://localhost:5173` (or the next available port). The app will automatically reload on code changes.

### Building for Production

```bash
npm run build
```

This generates an optimized production bundle in `client/dist/`. You can deploy this static folder to any web host.

## Project Structure

```
MathFriends/
├── client/                    # React frontend
│   ├── src/
│   │   ├── components/       # React components
│   │   ├── hooks/            # Custom hooks (usePracticeSession)
│   │   ├── services/         # API client
│   │   └── App.tsx           # Main app
│   ├── vite.config.ts
│   └── tailwind.config.js
├── server/                    # Express backend
│   ├── src/
│   │   ├── routes/           # API endpoints
│   │   └── services/         # Problem generation & validation
│   ├── tsconfig.json
│   └── package.json
├── shared/                    # Shared TypeScript types
│   └── src/types/problems.ts
└── package.json              # Root workspace config
```

## Features in Detail

### Problem Types

**Easy (Addition/Subtraction)**
- Numbers from 0-20
- No negative results
- Example: `7 + 5 = ?`

**Medium (Multiplication/Division/Powers)**
- Multiplication: 0-12 times tables
- Division: Only whole number results
- Powers: 2-5^2-5
- Examples: `6 × 7 = ?`, `12 ÷ 3 = ?`, `2^8 = ?`

**Hard (Linear Equations)**
- Format: `ax + b = c`, solve for x
- Integer solutions only
- Includes helpful hints
- Example: `3x + 5 = 14` (answer: x = 3)

### Progress Tracking

Your stats are automatically saved to browser localStorage:
- Total problems attempted
- Correct answers
- Current streak
- Best streak
- Per-difficulty statistics
- Overall accuracy

Progress persists across browser sessions until you clear your browser data.

## Troubleshooting

### Port Already in Use

If Vite can't use port 5173, it will automatically try the next available port (5174, 5175, etc.). Check the terminal output for the actual URL.

If you want to force a specific port:
```bash
cd client && npm run dev -- --port 5173
```

### Dependencies Installation Issues

```bash
# Clear node_modules and reinstall
rm -rf node_modules package-lock.json
npm install
```

### Browser Cache Issues

If the app behaves unexpectedly:
1. Press `Ctrl+Shift+Delete` (Windows) or `Cmd+Shift+Delete` (Mac) to clear browser cache
2. Or clear localStorage manually in browser DevTools
3. Hard refresh: `Ctrl+F5` (Windows) or `Cmd+Shift+R` (Mac)

## Future Enhancements

- 🏆 Leaderboards and achievements
- ⏱️ Timed quiz mode
- 👥 Multi-user support with accounts
- 📊 Teacher/parent dashboard
- 🎮 More gamification features
- 📝 Printable worksheets
- 🔊 Audio feedback
- 🌍 Multi-language support

## Contributing

This project is open for improvements! Feel free to:
- Add more problem types
- Enhance the UI/UX
- Improve problem generation algorithms
- Add new features

## License

MIT License - feel free to use this project for educational purposes.

## Support

For issues or questions, refer to the plan file at:
`/Users/olorin/.claude/plans/cheerful-dreaming-castle.md`

---

Happy learning! 🚀📚
