import React, { useEffect } from 'react';
import { usePracticeSession } from '../hooks/usePracticeSession';

export const FeedbackPanel: React.FC = () => {
  const { feedback, nextProblem, clearFeedback, isLoading } = usePracticeSession();

  useEffect(() => {
    // Auto-advance on correct answer
    if (feedback && feedback.correct && !isLoading) {
      const timer = setTimeout(() => {
        nextProblem();
      }, 2500);
      return () => clearTimeout(timer);
    }
    // Auto-advance when out of attempts
    if (feedback && feedback.outOfAttempts && !isLoading) {
      const timer = setTimeout(() => {
        nextProblem();
      }, 4000);
      return () => clearTimeout(timer);
    }
  }, [feedback, isLoading, nextProblem]);

  if (!feedback) return null;

  if (feedback.correct) {
    return (
      <div className="rounded-lg p-6 mb-6 text-center bg-green-100 border-2 border-green-500">
        <div className="text-4xl mb-2">&#x2705;</div>
        <p className="text-lg font-semibold text-green-800">{feedback.message}</p>
        <p className="text-gray-600 text-sm mt-2">Next problem loading...</p>
      </div>
    );
  }

  if (feedback.outOfAttempts) {
    return (
      <div className="rounded-lg p-6 mb-6 text-center bg-red-100 border-2 border-red-500">
        <div className="text-4xl mb-2">&#x274C;</div>
        <p className="text-lg font-semibold text-red-800">{feedback.message}</p>
        <p className="text-gray-600 text-sm mt-2">Moving to next problem...</p>
      </div>
    );
  }

  // Wrong answer but still has tries
  return (
    <div className="rounded-lg p-6 mb-6 text-center bg-amber-100 border-2 border-amber-500">
      <div className="text-4xl mb-2">&#x1F914;</div>
      <p className="text-lg font-semibold text-amber-800">{feedback.message}</p>
      <button
        onClick={clearFeedback}
        className="mt-4 px-4 py-2 bg-amber-600 text-white rounded font-semibold hover:bg-amber-700 transition-colors"
      >
        Try Again
      </button>
    </div>
  );
};
