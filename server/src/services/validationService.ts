import { ValidationResponse } from '../../../shared/src/types/problems';

export function validateAnswer(userAnswer: number, correctAnswer: number): ValidationResponse {
  const correct = Math.abs(userAnswer - correctAnswer) < 0.0001; // Account for floating point errors

  return {
    correct,
    correctAnswer,
    explanation: correct
      ? 'Great job! That\'s correct!'
      : `The correct answer is ${correctAnswer}. Try again!`
  };
}
