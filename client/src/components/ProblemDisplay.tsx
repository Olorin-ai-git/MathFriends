import React, { useState, useEffect } from 'react';
import { Problem, MAX_ATTEMPTS_PER_PROBLEM } from '../../../shared/src/types/problems';
import { usePracticeSession } from '../hooks/usePracticeSession';

interface ProblemDisplayProps {
  problem: Problem;
}

export const ProblemDisplay: React.FC<ProblemDisplayProps> = ({ problem }) => {
  const { submitAnswer, isLoading, attemptsRemaining, feedback } = usePracticeSession();
  const [userAnswer, setUserAnswer] = useState('');
  const [userAnswerY, setUserAnswerY] = useState('');

  const isBasicProblem = 'operation' in problem;
  const isSystemEquation = 'equation1' in problem;
  const inputDisabled = isLoading || (feedback?.correct) || (feedback?.outOfAttempts);

  useEffect(() => {
    setUserAnswer('');
    setUserAnswerY('');
  }, [problem.id]);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!userAnswer || inputDisabled) return;
    if (isSystemEquation && !userAnswerY) return;

    if (isSystemEquation) {
      const sys = problem as any;
      const xCorrect = parseFloat(userAnswer) === sys.answerX;
      const yCorrect = parseFloat(userAnswerY) === sys.answerY;
      await submitAnswer(xCorrect && yCorrect ? sys.answerX : sys.answerX + 1);
    } else {
      await submitAnswer(parseFloat(userAnswer));
    }
  };

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setUserAnswer(e.target.value);
  };

  return (
    <div className="bg-white rounded-lg shadow-lg p-8">
      <div className="mb-8">
        <div className="flex justify-between items-center mb-4">
          <p className="text-gray-600 text-sm">Problem:</p>
          <div className="flex gap-1">
            {Array.from({ length: MAX_ATTEMPTS_PER_PROBLEM }).map((_, i) => (
              <div
                key={i}
                className={`w-3 h-3 rounded-full ${
                  i < attemptsRemaining ? 'bg-blue-500' : 'bg-gray-300'
                }`}
              />
            ))}
          </div>
        </div>
        {isBasicProblem ? (
          <div className="text-5xl font-bold text-gray-800 text-center mb-2">
            {(problem as any).display}
          </div>
        ) : isSystemEquation ? (
          <div className="text-center mb-2">
            <div className="text-3xl font-bold text-gray-800 mb-2">
              {(problem as any).equation1}
            </div>
            <div className="text-3xl font-bold text-gray-800">
              {(problem as any).equation2}
            </div>
          </div>
        ) : (
          <div className="text-4xl font-bold text-gray-800 text-center mb-2">
            {(problem as any).equation}
          </div>
        )}
      </div>

      <form onSubmit={handleSubmit} className="flex flex-col gap-3">
        {isSystemEquation ? (
          <div className="flex gap-3">
            <div className="flex-1">
              <label className="block text-sm font-medium text-gray-600 mb-1">x =</label>
              <input
                type="number"
                value={userAnswer}
                onChange={handleInputChange}
                placeholder="Value of x"
                disabled={!!inputDisabled}
                autoFocus
                className="w-full px-4 py-3 border-2 border-gray-300 rounded-lg focus:outline-none focus:border-blue-500 text-lg disabled:bg-gray-100"
              />
            </div>
            <div className="flex-1">
              <label className="block text-sm font-medium text-gray-600 mb-1">y =</label>
              <input
                type="number"
                value={userAnswerY}
                onChange={(e) => setUserAnswerY(e.target.value)}
                placeholder="Value of y"
                disabled={!!inputDisabled}
                className="w-full px-4 py-3 border-2 border-gray-300 rounded-lg focus:outline-none focus:border-blue-500 text-lg disabled:bg-gray-100"
              />
            </div>
          </div>
        ) : (
          <input
            type="number"
            value={userAnswer}
            onChange={handleInputChange}
            placeholder="Enter your answer"
            disabled={!!inputDisabled}
            autoFocus
            className="w-full px-4 py-3 border-2 border-gray-300 rounded-lg focus:outline-none focus:border-blue-500 text-lg disabled:bg-gray-100"
          />
        )}
        <button
          type="submit"
          disabled={!!inputDisabled || !userAnswer || (isSystemEquation && !userAnswerY)}
          className="px-6 py-3 bg-blue-600 text-white font-semibold rounded-lg hover:bg-blue-700 disabled:bg-gray-400 transition-colors"
        >
          {isLoading ? 'Checking...' : 'Submit'}
        </button>
      </form>
    </div>
  );
};
