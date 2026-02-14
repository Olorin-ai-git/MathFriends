import { Router, Request, Response } from 'express';
import { generateProblems } from '../services/problemGenerator';
import { validateAnswer } from '../services/validationService';
import { Difficulty } from '../../../shared/src/types/problems';

const router = Router();

// GET /api/problems?difficulty=easy&count=1
router.get('/', (req: Request, res: Response) => {
  try {
    const difficulty = (req.query.difficulty as string)?.toLowerCase() || 'easy';
    const count = parseInt(req.query.count as string) || 1;

    // Validate difficulty
    const validDifficulties: Difficulty[] = ['superEasy', 'easy', 'medium', 'hard', 'extreme'];
    if (!validDifficulties.includes(difficulty as Difficulty)) {
      return res.status(400).json({
        error: 'Invalid difficulty. Must be superEasy, easy, medium, hard, or extreme.'
      });
    }

    // Validate count
    if (count < 1 || count > 100) {
      return res.status(400).json({
        error: 'Count must be between 1 and 100'
      });
    }

    const problems = generateProblems(difficulty as Difficulty, count);

    res.json({ problems });
  } catch (error) {
    res.status(500).json({ error: 'Failed to generate problems' });
  }
});

// POST /api/problems/validate
router.post('/validate', (req: Request, res: Response) => {
  try {
    const { problemId, userAnswer, correctAnswer } = req.body;

    if (typeof userAnswer !== 'number' || typeof correctAnswer !== 'number') {
      return res.status(400).json({
        error: 'userAnswer and correctAnswer must be numbers'
      });
    }

    const result = validateAnswer(userAnswer, correctAnswer);
    res.json(result);
  } catch (error) {
    res.status(500).json({ error: 'Failed to validate answer' });
  }
});

export default router;
