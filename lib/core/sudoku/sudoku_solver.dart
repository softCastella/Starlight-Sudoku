/// Sudoku solver using backtracking algorithm.
/// Can find a solution or count the number of solutions.
class SudokuSolver {
  /// Find a single solution to the puzzle
  /// Returns null if no solution exists
  static List<List<int>>? solve(List<List<int>> puzzle) {
    List<List<int>> board = puzzle.map((row) => [...row]).toList();
    if (_solveBT(board)) {
      return board;
    }
    return null;
  }

  /// Count the number of solutions (with early termination if > 1)
  /// Used to verify puzzle has unique solution
  static int countSolutions(List<List<int>> puzzle) {
    List<List<int>> board = puzzle.map((row) => [...row]).toList();
    return _countSolutionsBT(board, 0, 0);
  }

  /// Backtracking solver helper - finds one solution
  static bool _solveBT(List<List<int>> board) {
    // Find next empty cell
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (board[i][j] == 0) {
          // Try each number 1-9
          for (int num = 1; num <= 9; num++) {
            if (_isValid(board, i, j, num)) {
              board[i][j] = num;
              if (_solveBT(board)) {
                return true;
              }
              board[i][j] = 0; // Backtrack
            }
          }
          return false;
        }
      }
    }
    return true; // All cells filled
  }

  /// Backtracking solver helper - counts solutions with early termination
  static int _countSolutionsBT(List<List<int>> board, int row, int col) {
    // If we already found 2+ solutions, no need to continue
    int solutions = 0;

    // Find next empty cell starting from (row, col)
    int r = row;
    int c = col;
    bool found = false;

    for (int i = r; i < 9; i++) {
      for (int j = (i == r ? c : 0); j < 9; j++) {
        if (board[i][j] == 0) {
          r = i;
          c = j;
          found = true;
          break;
        }
      }
      if (found) break;
    }

    if (!found) {
      // All cells filled - found a solution
      return 1;
    }

    // Try each number 1-9
    for (int num = 1; num <= 9; num++) {
      if (_isValid(board, r, c, num)) {
        board[r][c] = num;
        solutions += _countSolutionsBT(board, r, c);
        board[r][c] = 0; // Backtrack

        // Early termination: we only care if there's 0, 1, or 2+ solutions
        if (solutions >= 2) {
          return solutions;
        }
      }
    }

    return solutions;
  }

  /// Check if placing number at (row, col) is valid
  static bool _isValid(List<List<int>> board, int row, int col, int num) {
    // Check row
    for (int j = 0; j < 9; j++) {
      if (board[row][j] == num) return false;
    }

    // Check column
    for (int i = 0; i < 9; i++) {
      if (board[i][col] == num) return false;
    }

    // Check 3x3 block
    int blockRow = (row ~/ 3) * 3;
    int blockCol = (col ~/ 3) * 3;
    for (int i = blockRow; i < blockRow + 3; i++) {
      for (int j = blockCol; j < blockCol + 3; j++) {
        if (board[i][j] == num) return false;
      }
    }

    return true;
  }
}
