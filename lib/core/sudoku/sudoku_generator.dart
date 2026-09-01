import 'dart:math';
import 'sudoku_solver.dart';
import 'sudoku_difficulty.dart';

/// Generates valid Sudoku puzzles with guaranteed unique solutions.
/// 
/// Process:
/// 1. Generate a complete valid 9x9 solution
/// 2. Remove numbers to create a puzzle
/// 3. Verify the puzzle has exactly one solution
class SudokuGenerator {
  static final Random _random = Random();

  /// Generate a complete, valid Sudoku solution
  static List<List<int>> generateSolution() {
    List<List<int>> board = List.generate(9, (_) => List.filled(9, 0));

    // Fill the first block (top-left 3x3)
    _fillBlock(board, 0, 0);

    // Fill the rest using backtracking
    if (!_fillBoard(board)) {
      // If failed, retry
      return generateSolution();
    }

    return board;
  }

  /// Generate a puzzle with unique solution based on difficulty
  static List<List<int>> generatePuzzle(SudokuDifficulty difficulty) {
    DifficultyConfig config = DifficultyConfig.getConfig(difficulty);

    int attempts = 0;
    const int maxAttempts = 5; // Try up to 5 times to find good puzzle

    while (attempts < maxAttempts) {
      List<List<int>> solution = generateSolution();
      List<List<int>> puzzle = solution.map((row) => [...row]).toList();

      // Remove clues while maintaining unique solution
      int removed = 0;
      int removalAttempts = 0;
      int targetRemoval = 81 - _random.nextInt(
        config.maxClues - config.minClues + 1,
      ) -
          config.minClues;

      while (removed < targetRemoval &&
          removalAttempts < config.maxRemovalAttempts) {
        int row = _random.nextInt(9);
        int col = _random.nextInt(9);

        if (puzzle[row][col] != 0) {
          int backup = puzzle[row][col];
          puzzle[row][col] = 0;

          // Check if puzzle still has unique solution
          int solutionCount = SudokuSolver.countSolutions(puzzle);
          if (solutionCount == 1) {
            removed++;
          } else {
            // Restore the number if puzzle becomes ambiguous
            puzzle[row][col] = backup;
          }
        }

        removalAttempts++;
      }

      // Verify puzzle has unique solution
      if (SudokuSolver.countSolutions(puzzle) == 1) {
        return puzzle;
      }

      attempts++;
    }

    // If we couldn't generate a good puzzle after retries, return the last one
    // (This shouldn't happen in practice)
    List<List<int>> solution = generateSolution();
    return _removeCluesForDifficulty(solution, config);
  }

  /// Fill the first 3x3 block randomly (for faster generation)
  static void _fillBlock(List<List<int>> board, int blockRow, int blockCol) {
    List<int> numbers = List.generate(9, (i) => i + 1);
    numbers.shuffle(_random);

    int index = 0;
    for (int i = blockRow; i < blockRow + 3; i++) {
      for (int j = blockCol; j < blockCol + 3; j++) {
        board[i][j] = numbers[index++];
      }
    }
  }

  /// Fill the board using backtracking with randomization
  static bool _fillBoard(List<List<int>> board) {
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (board[i][j] == 0) {
          // Create a shuffled list of numbers 1-9
          List<int> numbers = List.generate(9, (n) => n + 1);
          numbers.shuffle(_random);

          for (int num in numbers) {
            if (_isValidPlacement(board, i, j, num)) {
              board[i][j] = num;
              if (_fillBoard(board)) {
                return true;
              }
              board[i][j] = 0; // Backtrack
            }
          }

          return false;
        }
      }
    }

    return true;
  }

  /// Check if a placement is valid (for board generation)
  static bool _isValidPlacement(
      List<List<int>> board, int row, int col, int num) {
    // Check row (only check filled cells)
    for (int j = 0; j < 9; j++) {
      if (board[row][j] == num) return false;
    }

    // Check column (only check filled cells)
    for (int i = 0; i < 9; i++) {
      if (board[i][col] == num) return false;
    }

    // Check 3x3 block (only check filled cells)
    int blockRow = (row ~/ 3) * 3;
    int blockCol = (col ~/ 3) * 3;
    for (int i = blockRow; i < blockRow + 3; i++) {
      for (int j = blockCol; j < blockCol + 3; j++) {
        if (board[i][j] == num) return false;
      }
    }

    return true;
  }

  /// Helper: Remove clues to match difficulty (simpler approach)
  static List<List<int>> _removeCluesForDifficulty(
    List<List<int>> solution,
    DifficultyConfig config,
  ) {
    List<List<int>> puzzle = solution.map((row) => [...row]).toList();

    // Get list of all cells
    List<(int, int)> cells = [];
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        cells.add((i, j));
      }
    }

    cells.shuffle(_random);

    int removed = 0;
    int targetRemoval = 81 - (_random.nextInt(
          config.maxClues - config.minClues + 1,
        ) +
        config.minClues);

    for (var (row, col) in cells) {
      if (removed >= targetRemoval) break;

      int backup = puzzle[row][col];
      puzzle[row][col] = 0;

      // Verify unique solution
      if (SudokuSolver.countSolutions(puzzle) == 1) {
        removed++;
      } else {
        puzzle[row][col] = backup;
      }
    }

    return puzzle;
  }
}
