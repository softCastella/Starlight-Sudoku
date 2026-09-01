/// Represents a 9x9 Sudoku board with complete game state.
/// 
/// This class separates concerns:
/// - Solution: The correct answer to the puzzle
/// - Puzzle: Original given numbers
/// - PlayerBoard: Player's current input
/// - MemoCandidates: Player's notes/candidates for each cell
class SudokuBoard {
  /// The complete solution (all 81 cells filled)
  final List<List<int>> solution;

  /// Original puzzle (given numbers that cannot be changed)
  final List<List<int>> puzzle;

  /// Player's current board state
  final List<List<int>> playerBoard;

  /// Memo candidates for each cell (3x3 grid of possible numbers)
  final List<List<Set<int>>> memoCandidates;

  /// Which cells are fixed (from the original puzzle)
  final List<List<bool>> fixedCells;

  /// Track if game is completed
  bool isCompleted = false;

  SudokuBoard({
    required this.solution,
    required this.puzzle,
    List<List<int>>? playerBoard,
    List<List<Set<int>>>? memoCandidates,
    List<List<bool>>? fixedCells,
  })  : playerBoard = playerBoard ?? _initializePlayerBoard(puzzle),
        memoCandidates = memoCandidates ?? _initializeMemoCandidates(),
        fixedCells = fixedCells ?? _initializeFixedCells(puzzle);

  /// Initialize player board from puzzle (empty cells are 0)
  static List<List<int>> _initializePlayerBoard(List<List<int>> puzzle) {
    return List.generate(
      9,
      (i) => List.generate(9, (j) => puzzle[i][j]),
    );
  }

  /// Initialize memo candidates grid (all empty initially)
  static List<List<Set<int>>> _initializeMemoCandidates() {
    return List.generate(
      9,
      (_) => List.generate(9, (_) => <int>{}),
    );
  }

  /// Mark which cells are fixed from the puzzle
  static List<List<bool>> _initializeFixedCells(List<List<int>> puzzle) {
    return List.generate(
      9,
      (i) => List.generate(9, (j) => puzzle[i][j] != 0),
    );
  }

  /// Get the value at position (row, col) from player board
  int getValue(int row, int col) => playerBoard[row][col];

  /// Set a value at position (row, col)
  /// Returns true if successful, false if cell is fixed
  bool setValue(int row, int col, int value) {
    if (fixedCells[row][col]) return false;
    if (value < 0 || value > 9) return false;

    playerBoard[row][col] = value;

    // Clear memo candidates when a value is set
    if (value != 0) {
      memoCandidates[row][col].clear();
    }

    return true;
  }

  /// Check if a cell is fixed (from the original puzzle)
  bool isFixedCell(int row, int col) => fixedCells[row][col];

  /// Get memo candidates for a cell (as List)
  List<int> getMemo(int row, int col) => memoCandidates[row][col].toList();

  /// Add a candidate to memo
  void addMemo(int row, int col, int number) {
    if (playerBoard[row][col] == 0) {
      memoCandidates[row][col].add(number);
    }
  }

  /// Remove a candidate from memo
  void removeMemo(int row, int col, int number) {
    memoCandidates[row][col].remove(number);
  }

  /// Clear all memo for a cell
  void clearMemo(int row, int col) {
    memoCandidates[row][col].clear();
  }

  /// Get all empty cells
  List<(int, int)> getEmptyCells() {
    List<(int, int)> empty = [];
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (playerBoard[i][j] == 0) {
          empty.add((i, j));
        }
      }
    }
    return empty;
  }

  /// Check if the board is completely filled
  bool isFilled() {
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (playerBoard[i][j] == 0) return false;
      }
    }
    return true;
  }

  /// Create a deep copy of this board
  SudokuBoard copy() {
    return SudokuBoard(
      solution: solution.map((row) => [...row]).toList(),
      puzzle: puzzle.map((row) => [...row]).toList(),
      playerBoard: playerBoard.map((row) => [...row]).toList(),
      memoCandidates: memoCandidates.map((row) => row.map((s) => {...s}).toList()).toList(),
      fixedCells: fixedCells.map((row) => [...row]).toList(),
    );
  }
}
