import { useEffect } from 'react';
import { usePracticeSession } from './hooks/usePracticeSession';
import { DifficultySelector } from './components/DifficultySelector';
import { ProblemDisplay } from './components/ProblemDisplay';
import { FeedbackPanel } from './components/FeedbackPanel';
import './index.css';

function App() {
  const { currentProblem, loadProblem, stats, difficulty, showDifficultySelector, showingSelector } = usePracticeSession();

  useEffect(() => {
    if (!currentProblem && !showingSelector) {
      console.log('Loading problem for difficulty:', difficulty);
      loadProblem();
    }
  }, [difficulty, currentProblem, showingSelector, loadProblem]);

  const handleChangeLevel = () => {
    console.log('Change level clicked');
    showDifficultySelector();
  };

  if (!currentProblem || showingSelector) {
    return <DifficultySelector />;
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 p-4">
      <div className="max-w-2xl mx-auto py-8">
        {/* Header */}
        <div className="flex justify-between items-center mb-8">
          <div>
            <h1 className="text-3xl font-bold text-gray-800">MathFriends</h1>
            <p className="text-gray-600 capitalize">
              {difficulty === 'superEasy'
                ? '🧸 Super Easy - Simple Addition (0-5)'
                : difficulty === 'easy'
                ? '🌟 Easy - Addition & Subtraction'
                : difficulty === 'medium'
                ? '⭐ Medium - Multiplication, Division & Powers'
                : difficulty === 'hard'
                ? '🚀 Hard - Simple Equations'
                : '🔥 Extreme - Quadratics & Systems'}
            </p>
          </div>
          <button
            onClick={handleChangeLevel}
            className="px-4 py-2 bg-white text-gray-800 rounded-lg shadow hover:shadow-lg active:shadow-md transition-all"
          >
            Change Level
          </button>
        </div>

        {/* Stats */}
        <div className="grid grid-cols-4 gap-4 mb-8">
          <div className="bg-white rounded-lg p-4 shadow">
            <p className="text-gray-600 text-sm">Attempted</p>
            <p className="text-2xl font-bold text-gray-800">{stats.totalAttempted}</p>
          </div>
          <div className="bg-white rounded-lg p-4 shadow">
            <p className="text-gray-600 text-sm">Correct</p>
            <p className="text-2xl font-bold text-green-600">{stats.correct}</p>
          </div>
          <div className="bg-white rounded-lg p-4 shadow">
            <p className="text-gray-600 text-sm">Current Streak</p>
            <p className="text-2xl font-bold text-blue-600">{stats.currentStreak}</p>
          </div>
          <div className="bg-white rounded-lg p-4 shadow">
            <p className="text-gray-600 text-sm">Best Streak</p>
            <p className="text-2xl font-bold text-purple-600">{stats.bestStreak}</p>
          </div>
        </div>

        {/* Feedback */}
        <FeedbackPanel />

        {/* Problem Display */}
        <ProblemDisplay problem={currentProblem} />

        {/* Accuracy */}
        {stats.totalAttempted > 0 && (
          <div className="mt-8 text-center">
            <p className="text-gray-600">
              Accuracy: {Math.round((stats.correct / stats.totalAttempted) * 100)}%
            </p>
          </div>
        )}
      </div>
    </div>
  );
}

export default App;
