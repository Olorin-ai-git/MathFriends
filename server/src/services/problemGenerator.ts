import {
  BasicProblem,
  ComparisonProblem,
  EquationProblem,
  SystemEquationProblem,
  Difficulty,
} from "../../../shared/src/types/problems";

function generateId(): string {
  return Math.random().toString(36).substring(2, 11);
}

function randomInt(min: number, max: number): number {
  return Math.floor(Math.random() * (max - min + 1)) + min;
}

function randomChoice<T>(arr: T[]): T {
  return arr[Math.floor(Math.random() * arr.length)];
}

/**
 * Generate a Super Easy level problem (Pre-K / Kindergarten)
 * Simple addition with numbers 0-10
 */
function generateSuperEasyProblem(): BasicProblem {
  const num1 = randomInt(0, 5);
  const num2 = randomInt(0, 5);
  const answer = num1 + num2;

  return {
    id: generateId(),
    num1,
    num2,
    operation: "+",
    answer,
    difficulty: "superEasy",
    display: `${num1} + ${num2} = ?`,
  };
}

/**
 * Generate an Easy level problem (1st grade)
 * Addition and subtraction with numbers 0-20, no negative results
 */
function generateEasyProblem(): BasicProblem {
  const operation = Math.random() > 0.5 ? "+" : "-";

  let num1: number, num2: number, answer: number;

  if (operation === "+") {
    num1 = randomInt(0, 20);
    num2 = randomInt(0, 20 - num1);
    answer = num1 + num2;
  } else {
    num1 = randomInt(0, 20);
    num2 = randomInt(0, num1); // Prevent negative results
    answer = num1 - num2;
  }

  return {
    id: generateId(),
    num1,
    num2,
    operation: operation as "+" | "-",
    answer,
    difficulty: "easy",
    display: `${num1} ${operation} ${num2} = ?`,
  };
}

/**
 * Generate a Medium level problem (2nd-4th grade)
 * Multiplication (0-12 tables), division (whole numbers), powers (2-5^2-5)
 */
function generateMediumProblem(): BasicProblem {
  const problemTypes = ["*", "/", "^"];
  const problemType = randomChoice(problemTypes);

  let num1: number, num2: number, answer: number;

  if (problemType === "*") {
    num1 = randomInt(0, 12);
    num2 = randomInt(0, 12);
    answer = num1 * num2;
  } else if (problemType === "/") {
    // Generate division that results in whole numbers
    num2 = randomInt(1, 12);
    const quotient = randomInt(1, 12);
    num1 = num2 * quotient;
    answer = quotient;
  } else {
    // Powers: 2^2 to 5^5
    num1 = randomChoice([2, 3, 4, 5]);
    num2 = randomInt(2, 5);
    answer = Math.pow(num1, num2);
  }

  const display =
    problemType === "^"
      ? `${num1}^${num2} = ?`
      : `${num1} ${problemType} ${num2} = ?`;

  return {
    id: generateId(),
    num1,
    num2,
    operation: problemType as "*" | "/" | "^",
    answer,
    difficulty: "medium",
    display,
  };
}

/**
 * Generate a Hard level problem (5th grade)
 * Simple linear equations: ax + b = c, solve for x
 * Ensures integer solutions
 */
function generateHardProblem(): EquationProblem {
  // Generate x first
  const x = randomInt(-10, 10);

  // Generate coefficient and constant
  const a = randomInt(1, 10);
  const b = randomInt(-20, 20);

  // Calculate the right side: c = ax + b
  const c = a * x + b;

  const equation = `${a}x ${b >= 0 ? "+" : "-"} ${Math.abs(b)} = ${c}`;

  return {
    id: generateId(),
    equation,
    answer: x,
    difficulty: "hard",
  };
}

function formatTerm(coeff: number, variable: string, isFirst: boolean): string {
  const absCoeff = Math.abs(coeff);
  const sign = coeff >= 0 ? (isFirst ? "" : " + ") : isFirst ? "-" : " - ";
  const coeffStr = absCoeff === 1 ? "" : `${absCoeff}`;
  return `${sign}${coeffStr}${variable}`;
}

/**
 * Generate a system of two linear equations with two unknowns:
 *   a1*x + b1*y = c1
 *   a2*x + b2*y = c2
 */
function generateSystemEquationProblem(): SystemEquationProblem {
  const x = randomInt(-10, 10);
  const y = randomInt(-10, 10);

  let a1 = randomInt(1, 6);
  let b1 = randomInt(1, 6);
  let a2 = randomInt(1, 6);
  let b2 = randomInt(1, 6);

  while (a1 * b2 - a2 * b1 === 0) {
    b2 = randomInt(1, 6);
  }

  if (Math.random() > 0.5) b1 = -b1;
  if (Math.random() > 0.5) a2 = -a2;

  const c1 = a1 * x + b1 * y;
  const c2 = a2 * x + b2 * y;

  const equation1 = `${formatTerm(a1, "x", true)}${formatTerm(b1, "y", false)} = ${c1}`;
  const equation2 = `${formatTerm(a2, "x", true)}${formatTerm(b2, "y", false)} = ${c2}`;

  return {
    id: generateId(),
    equation1,
    equation2,
    answerX: x,
    answerY: y,
    difficulty: "extreme",
  };
}

/**
 * Generate a quadratic equation: x² + bx + c = 0
 * With integer roots r1, r2
 */
function generateQuadraticProblem(): EquationProblem {
  const r1 = randomInt(-8, 8);
  const r2 = randomInt(-8, 8);

  const b = -(r1 + r2);
  const c = r1 * r2;
  const answer = Math.min(r1, r2);

  let equation = "x²";
  if (b !== 0) {
    equation +=
      b > 0 ? ` + ${b === 1 ? "" : b}x` : ` - ${b === -1 ? "" : Math.abs(b)}x`;
  }
  if (c !== 0) {
    equation += c > 0 ? ` + ${c}` : ` - ${Math.abs(c)}`;
  }
  equation += " = 0";

  return {
    id: generateId(),
    equation,
    answer,
    difficulty: "extreme",
  };
}

function generateComparisonProblem(): ComparisonProblem {
  const operation = randomChoice(["+", "-", "*"] as const);

  let num1: number, num2: number, expressionResult: number;

  if (operation === "+") {
    num1 = randomInt(1, 20);
    num2 = randomInt(1, 20);
    expressionResult = num1 + num2;
  } else if (operation === "-") {
    num1 = randomInt(5, 30);
    num2 = randomInt(1, num1 - 1);
    expressionResult = num1 - num2;
  } else {
    num1 = randomInt(2, 10);
    num2 = randomInt(2, 10);
    expressionResult = num1 * num2;
  }

  const operationSymbol = operation === "*" ? "\u00D7" : operation;
  const expression = `${num1} ${operationSymbol} ${num2}`;

  // Generate a comparison number: greater, less, or equal to the result
  let comparisonNumber: number;
  const roll = Math.random();
  if (roll < 0.33) {
    comparisonNumber = expressionResult;
  } else if (roll < 0.66) {
    comparisonNumber = expressionResult + randomInt(1, 10);
  } else {
    comparisonNumber = expressionResult - randomInt(1, 10);
  }

  // 0 = less than, 1 = greater than, 2 = equal to
  let answer: number;
  if (comparisonNumber > expressionResult) {
    answer = 1;
  } else if (comparisonNumber < expressionResult) {
    answer = 0;
  } else {
    answer = 2;
  }

  return {
    id: generateId(),
    expression,
    expressionResult,
    comparisonNumber,
    answer,
    difficulty: "comparison",
    display: `Is ${comparisonNumber} greater than, less than, or equal to ${expression} ?`,
  };
}

/**
 * Generate an Extreme level problem (6th+ grade)
 * Randomly picks between system of equations (x & y) or quadratic equations
 */
function generateExtremeProblem(): EquationProblem | SystemEquationProblem {
  return Math.random() > 0.5
    ? generateSystemEquationProblem()
    : generateQuadraticProblem();
}

export function generateProblem(
  difficulty: Difficulty,
): BasicProblem | ComparisonProblem | EquationProblem | SystemEquationProblem {
  switch (difficulty) {
    case "superEasy":
      return generateSuperEasyProblem();
    case "easy":
      return generateEasyProblem();
    case "comparison":
      return generateComparisonProblem();
    case "medium":
      return generateMediumProblem();
    case "hard":
      return generateHardProblem();
    case "extreme":
      return generateExtremeProblem();
    default:
      throw new Error(`Unknown difficulty: ${difficulty}`);
  }
}

export function generateProblems(
  difficulty: Difficulty,
  count: number,
): (
  | BasicProblem
  | ComparisonProblem
  | EquationProblem
  | SystemEquationProblem
)[] {
  const problems = [];
  for (let i = 0; i < count; i++) {
    problems.push(generateProblem(difficulty));
  }
  return problems;
}
