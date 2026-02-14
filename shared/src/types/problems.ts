export type Difficulty = 'superEasy' | 'easy' | 'medium' | 'hard' | 'extreme';

export const MAX_ATTEMPTS_PER_PROBLEM = 5;
export type Operation = '+' | '-' | '*' | '/' | '^';

export interface BasicProblem {
  id: string;
  num1: number;
  num2: number;
  operation: Operation;
  answer: number;
  difficulty: Difficulty;
  display: string;
}

export interface EquationProblem {
  id: string;
  equation: string;
  answer: number;
  difficulty: 'hard' | 'extreme';
}

export interface SystemEquationProblem {
  id: string;
  equation1: string;
  equation2: string;
  answerX: number;
  answerY: number;
  difficulty: 'extreme';
}

export type Problem = BasicProblem | EquationProblem | SystemEquationProblem;

export interface ValidationRequest {
  problemId: string;
  userAnswer: number;
}

export interface ValidationResponse {
  correct: boolean;
  correctAnswer: number;
  explanation?: string;
}

export interface PracticeStats {
  totalAttempted: number;
  correct: number;
  currentStreak: number;
  bestStreak: number;
  difficultyStats: {
    superEasy: {
      attempted: number;
      correct: number;
    };
    easy: {
      attempted: number;
      correct: number;
    };
    medium: {
      attempted: number;
      correct: number;
    };
    hard: {
      attempted: number;
      correct: number;
    };
    extreme: {
      attempted: number;
      correct: number;
    };
  };
}
