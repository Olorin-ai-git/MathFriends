import { create } from "zustand";
import {
  Difficulty,
  PracticeStats,
  MAX_ATTEMPTS_PER_PROBLEM,
} from "../../../shared/src/types/problems";
import { getProblem, validateAnswer } from "../services/api";

interface SessionState {
  difficulty: Difficulty;
  currentProblem: any | null;
  currentAnswer: number | null;
  isLoading: boolean;
  error: string | null;
  feedback: {
    correct: boolean;
    message: string;
    outOfAttempts?: boolean;
  } | null;
  attemptsRemaining: number;
  stats: PracticeStats;
  showingSelector: boolean;
  setDifficulty: (difficulty: Difficulty) => void;
  showDifficultySelector: () => void;
  loadProblem: () => Promise<void>;
  submitAnswer: (userAnswer: number) => Promise<void>;
  nextProblem: () => Promise<void>;
  clearFeedback: () => void;
  resetSession: () => void;
}

const initialStats: PracticeStats = {
  totalAttempted: 0,
  correct: 0,
  currentStreak: 0,
  bestStreak: 0,
  difficultyStats: {
    superEasy: { attempted: 0, correct: 0 },
    easy: { attempted: 0, correct: 0 },
    comparison: { attempted: 0, correct: 0 },
    medium: { attempted: 0, correct: 0 },
    hard: { attempted: 0, correct: 0 },
    extreme: { attempted: 0, correct: 0 },
  },
};

// Load stats from localStorage
function loadStatsFromStorage(): PracticeStats {
  const stored = localStorage.getItem("mathfriends-stats");
  if (stored) {
    try {
      return JSON.parse(stored);
    } catch (e) {
      return initialStats;
    }
  }
  return initialStats;
}

function saveStatsToStorage(stats: PracticeStats) {
  localStorage.setItem("mathfriends-stats", JSON.stringify(stats));
}

function formatCorrectAnswer(problem: any): string {
  if ("answerX" in problem) {
    return `x = ${problem.answerX}, y = ${problem.answerY}`;
  }
  if ("comparisonNumber" in problem) {
    if (problem.answer === 1) return "Greater Than";
    if (problem.answer === 2) return "Equal To";
    return "Less Than";
  }
  return `${problem.answer}`;
}

export const usePracticeSession = create<SessionState>((set, get) => ({
  difficulty: "easy",
  currentProblem: null,
  currentAnswer: null,
  isLoading: false,
  error: null,
  feedback: null,
  attemptsRemaining: MAX_ATTEMPTS_PER_PROBLEM,
  stats: loadStatsFromStorage(),
  showingSelector: true,

  setDifficulty: (difficulty: Difficulty) => {
    set({
      difficulty,
      currentProblem: null,
      currentAnswer: null,
      feedback: null,
      attemptsRemaining: MAX_ATTEMPTS_PER_PROBLEM,
      showingSelector: false,
    });
  },

  showDifficultySelector: () => {
    set({
      currentProblem: null,
      currentAnswer: null,
      feedback: null,
      attemptsRemaining: MAX_ATTEMPTS_PER_PROBLEM,
      showingSelector: true,
    });
  },

  loadProblem: async () => {
    set({
      isLoading: true,
      error: null,
      feedback: null,
      attemptsRemaining: MAX_ATTEMPTS_PER_PROBLEM,
    });
    try {
      const problemData = await getProblem(get().difficulty);
      // Extract the answer - for system equations use answerX as the validation target
      const answer =
        "answerX" in problemData
          ? (problemData as any).answerX
          : (problemData as any).answer;
      set({ currentProblem: problemData, currentAnswer: answer });
    } catch (error) {
      set({ error: "Failed to load problem" });
    } finally {
      set({ isLoading: false });
    }
  },

  submitAnswer: async (userAnswer: number) => {
    const {
      currentProblem,
      currentAnswer,
      stats,
      difficulty,
      attemptsRemaining,
    } = get();
    if (!currentProblem || currentAnswer === null) {
      return;
    }

    set({ isLoading: true });
    try {
      const result = await validateAnswer(userAnswer, currentAnswer);
      const correct = result.correct;

      if (correct) {
        // Correct answer - update stats and advance
        const newStats = { ...stats };
        newStats.totalAttempted += 1;
        newStats.difficultyStats[difficulty].attempted += 1;
        newStats.correct += 1;
        newStats.currentStreak += 1;
        newStats.difficultyStats[difficulty].correct += 1;

        if (newStats.currentStreak > newStats.bestStreak) {
          newStats.bestStreak = newStats.currentStreak;
        }

        saveStatsToStorage(newStats);
        set({
          stats: newStats,
          attemptsRemaining: MAX_ATTEMPTS_PER_PROBLEM,
          feedback: {
            correct: true,
            message: "Great job! That's correct!",
          },
        });
      } else {
        const remaining = attemptsRemaining - 1;

        if (remaining <= 0) {
          // Out of attempts - record as incorrect, show answer, advance
          const newStats = { ...stats };
          newStats.totalAttempted += 1;
          newStats.difficultyStats[difficulty].attempted += 1;
          newStats.currentStreak = 0;

          saveStatsToStorage(newStats);
          set({
            stats: newStats,
            attemptsRemaining: 0,
            feedback: {
              correct: false,
              message: `The correct answer is ${formatCorrectAnswer(currentProblem)}`,
              outOfAttempts: true,
            },
          });
        } else {
          // Still has attempts - let them try again
          set({
            attemptsRemaining: remaining,
            feedback: {
              correct: false,
              message: `Not quite! ${remaining} ${remaining === 1 ? "try" : "tries"} remaining`,
            },
          });
        }
      }
    } catch (error) {
      set({ error: "Failed to validate answer" });
    } finally {
      set({ isLoading: false });
    }
  },

  nextProblem: async () => {
    set({ feedback: null, attemptsRemaining: MAX_ATTEMPTS_PER_PROBLEM });
    await get().loadProblem();
  },

  clearFeedback: () => {
    set({ feedback: null });
  },

  resetSession: () => {
    saveStatsToStorage(initialStats);
    set({
      currentProblem: null,
      feedback: null,
      attemptsRemaining: MAX_ATTEMPTS_PER_PROBLEM,
      stats: initialStats,
    });
  },
}));
