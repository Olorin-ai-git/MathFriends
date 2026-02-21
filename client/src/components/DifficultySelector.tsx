import React from "react";
import { Difficulty } from "../../../shared/src/types/problems";
import { usePracticeSession } from "../hooks/usePracticeSession";

interface DifficultyCard {
  level: Difficulty;
  title: string;
  description: string;
  emoji: string;
  bgColor: string;
}

const difficulties: DifficultyCard[] = [
  {
    level: "superEasy",
    title: "Super Easy",
    description: "Pre-K\nSimple Addition (0-5)",
    emoji: "🧸",
    bgColor: "bg-yellow-100",
  },
  {
    level: "easy",
    title: "Easy",
    description: "1st Grade\nAddition & Subtraction",
    emoji: "🌟",
    bgColor: "bg-green-100",
  },
  {
    level: "comparison",
    title: "Greater / Less",
    description: "1st-2nd Grade\nCompare Numbers to Results",
    emoji: "⚖️",
    bgColor: "bg-teal-100",
  },
  {
    level: "medium",
    title: "Medium",
    description: "2nd-4th Grade\nMultiplication, Division & Powers",
    emoji: "⭐",
    bgColor: "bg-blue-100",
  },
  {
    level: "hard",
    title: "Hard",
    description: "5th Grade\nSimple Equations",
    emoji: "🚀",
    bgColor: "bg-purple-100",
  },
  {
    level: "extreme",
    title: "Extreme",
    description: "6th+ Grade\nQuadratics & Systems of Equations",
    emoji: "🔥",
    bgColor: "bg-red-100",
  },
];

export const DifficultySelector: React.FC = () => {
  const { setDifficulty, loadProblem } = usePracticeSession();

  const handleSelectDifficulty = (level: Difficulty) => {
    console.log("Difficulty selected:", level);
    setDifficulty(level);
    // Small delay to allow state update
    setTimeout(() => {
      console.log("Loading problem for difficulty:", level);
      loadProblem();
    }, 0);
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 flex flex-col items-center justify-center p-4">
      <div className="max-w-4xl w-full">
        <div className="text-center mb-12">
          <h1 className="text-5xl font-bold text-gray-800 mb-2">MathFriends</h1>
          <p className="text-xl text-gray-600">Learn math the fun way!</p>
        </div>

        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-6 gap-6 mb-8">
          {difficulties.map((card) => (
            <button
              key={card.level}
              onClick={() => handleSelectDifficulty(card.level)}
              className={`${card.bgColor} rounded-lg p-6 shadow-lg hover:shadow-xl transform hover:scale-105 transition-all cursor-pointer border-2 border-transparent hover:border-gray-300`}
            >
              <div className="text-6xl mb-4">{card.emoji}</div>
              <h2 className="text-2xl font-bold text-gray-800 mb-2">
                {card.title}
              </h2>
              <p className="text-gray-700 whitespace-pre-line">
                {card.description}
              </p>
            </button>
          ))}
        </div>

        <div className="bg-white rounded-lg p-6 shadow-md">
          <h3 className="text-lg font-semibold text-gray-800 mb-4">
            How to Play:
          </h3>
          <ul className="text-gray-700 space-y-2">
            <li>✓ Select a difficulty level above</li>
            <li>✓ Answer each math problem</li>
            <li>✓ Get instant feedback</li>
            <li>✓ Build your streak and improve your skills!</li>
          </ul>
        </div>
      </div>
    </div>
  );
};
