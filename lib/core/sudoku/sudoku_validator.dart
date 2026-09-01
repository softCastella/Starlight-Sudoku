/// Validates Sudoku board states, rules, and completeness.
/// UI-independent validation logic.
class SudokuValidator {
  /// Check if a number is valid in a specific position
  static bool isValidMove(List<List<int>> board, int row, int col, int number) {
    if (number < 1 || number > 9) return false;
    if (board[row][col] != 0) return false; // Cell already filled

    // Check row
    for (int j = 0; j < 9; j++) {
      if (j != col && board[row][j] == number) return false;
    }

    // Check column
    for (int i = 0; i < 9; i++) {
      if (i != row && board[i][col] == number) return false;
    }

    // Check 3x3 block
    int blockRow = (row ~/ 3) * 3;
    int blockCol = (col ~/ 3) * 3;
    for (int i = blockRow; i < blockRow + 3; i++) {
      for (int j = blockCol; j < blockCol + 3; j++) {
        if ((i != row || j != col) && board[i][j] == number) return false;
      }
    }

    return true;
  }

  /// Check if placing a number at (row, col) causes a conflict
  static bool hasConflict(List<List<int>> board, int row, int col, int number) {
    return !isValidMove(board, row, col, number);
  }

  /// Check if a row has duplicates
  static bool isRowValid(List<List<int>> board, int row) {
    Set<int> seen = {};
    for (int j = 0; j < 9; j++) {
      int value = board[row][j];
      if (value != 0) {
        if (seen.contains(value)) return false;
        seen.add(value);
      }
    }
    return true;
  }

  /// Check if a column has duplicates
  static bool isColumnValid(List<List<int>> board, int col) {
    Set<int> seen = {};
    for (int i = 0; i < 9; i++) {
      int value = board[i][col];
      if (value != 0) {
        if (seen.contains(value)) return false;
        seen.add(value);
      }
    }
    return true;
  }

  /// Check if a 3x3 block is valid
  static bool isBlockValid(List<List<int>> board, int blockRow, int blockCol) {
    Set<int> seen = {};
    for (int i = blockRow; i < blockRow + 3; i++) {
      for (int j = blockCol; j < blockCol + 3; j++) {
        int value = board[i][j];
        if (value != 0) {
          if (seen.contains(value)) return false;
          seen.add(value);
        }
      }
    }
    return true;
  }

  /// Check if the entire board is valid (all rows, columns, blocks)
  static bool isBoardValid(List<List<int>> board) {
    // Check all rows
    for (int i = 0; i < 9; i++) {
      if (!isRowValid(board, i)) return false;
    }

    // Check all columns
    for (int j = 0; j < 9; j++) {
      if (!isColumnValid(board, j)) return false;
    }

    // Check all 3x3 blocks
    for (int i = 0; i < 9; i += 3) {
      for (int j = 0; j < 9; j += 3) {
        if (!isBlockValid(board, i, j)) return false;
      }
    }

    return true;
  }

  /// Check if the puzzle is complete (all cells filled with valid solution)
  static bool isPuzzleComplete(List<List<int>> board, List<List<int>> solution) {
    // First check if all cells are filled
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (board[i][j] == 0) return false;
      }
    }

    // Then check if it matches the solution
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (board[i][j] != solution[i][j]) return false;
      }
    }

    return true;
  }

  /// Check if a complete board is a valid Sudoku solution
  static bool isValidSolution(List<List<int>> board) {
    // Check all cells are filled
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (board[i][j] < 1 || board[i][j] > 9) return false;
      }
    }

    return isBoardValid(board);
  }

  /// Get all invalid cells in the current board (comparing with solution)
  static List<(int, int)> getInvalidCells(
      List<List<int>> board, List<List<int>> solution) {
    List<(int, int)> invalid = [];
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (board[i][j] != 0 && board[i][j] != solution[i][j]) {
          invalid.add((i, j));
        }
      }
    }
    return invalid;
  }

  /// Check if a specific cell is wrong
  static bool isCellWrong(
      int row, int col, List<List<int>> board, List<List<int>> solution) {
    if (board[row][col] == 0) return false;
    return board[row][col] != solution[row][col];
  }
}
