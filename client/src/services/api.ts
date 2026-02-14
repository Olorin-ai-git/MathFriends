import { Difficulty, ValidationResponse } from '../../../shared/src/types/problems';
import { generateProblem, Problem } from '../utils/problemGenerator';

export async function getProblem(difficulty: Difficulty): Promise<Problem> {
  // Generate problem client-side
  return Promise.resolve(generateProblem(difficulty));
}

export async function validateAnswer(
  userAnswer: number,
  correctAnswer: number
): Promise<ValidationResponse> {
  const correct = Math.abs(userAnswer - correctAnswer) < 0.0001;

  return Promise.resolve({
    correct,
    correctAnswer,
    explanation: correct
      ? 'Great job! That\'s correct!'
      : `The correct answer is ${correctAnswer}`
  });
}
