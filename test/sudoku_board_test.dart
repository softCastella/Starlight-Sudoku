import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_game/core/sudoku/sudoku_board.dart';

void main() {
  group('SudokuBoard Tests', () {
    late List<List<int>> sampleSolution;
    late List<List<int>> samplePuzzle;

    setUp(() {
      // Create a simple valid solution for testing
      sampleSolution = [
        [5, 3, 4, 6, 7, 8, 9, 1, 2],
        [6, 7, 2, 1, 9, 5, 3, 4, 8],
        [1, 9, 8, 3, 4, 2, 5, 6, 7],
        [8, 5, 9, 7, 6, 1, 4, 2, 3],
        [4, 2, 6, 8, 5, 3, 7, 9, 1],
        [7, 1, 3, 9, 2, 4, 8, 5, 6],
        [9, 6, 1, 5, 3, 7, 2, 8, 4],
        [2, 8, 7, 4, 1, 9, 6, 3, 5],
        [3, 4, 5, 2, 8, 6, 1, 7, 9],
      ];

      // Create puzzle with some empty cells
      samplePuzzle = sampleSolution.map((row) => [...row]).toList();
      samplePuzzle[0][0] = 0;
      samplePuzzle[0][1] = 0;
      samplePuzzle[1][0] = 0;
    });

    test('SudokuBoard initializes correctly', () {
      SudokuBoard board = SudokuBoard(
        solution: sampleSolution,
        puzzle: samplePuzzle,
      );

      expect(board.playerBoard[0][0], equals(0));
      expect(board.playerBoard[1][2], equals(2));
      expect(board.fixedCells[1][2], equals(true));
      expect(board.fixedCells[0][0], equals(false));
    });

    test('setValue works for empty cells', () {
      SudokuBoard board = SudokuBoard(
        solution: sampleSolution,
        puzzle: samplePuzzle,
      );

      bool success = board.setValue(0, 0, 5);
      expect(success, equals(true));
      expect(board.getValue(0, 0), equals(5));
    });

    test('setValue fails for fixed cells', () {
      SudokuBoard board = SudokuBoard(
        solution: sampleSolution,
        puzzle: samplePuzzle,
      );

      bool success = board.setValue(1, 2, 5);
      expect(success, equals(false));
      expect(board.getValue(1, 2), equals(2)); // Unchanged
    });

    test('Memo operations work correctly', () {
      SudokuBoard board = SudokuBoard(
        solution: sampleSolution,
        puzzle: samplePuzzle,
      );

      board.addMemo(0, 0, 1);
      board.addMemo(0, 0, 2);
      expect(board.getMemo(0, 0).length, equals(2));
      expect(board.getMemo(0, 0).contains(1), equals(true));

      board.removeMemo(0, 0, 1);
      expect(board.getMemo(0, 0).length, equals(1));

      board.clearMemo(0, 0);
      expect(board.getMemo(0, 0).length, equals(0));
    });

    test('getEmptyCells returns correct cells', () {
      SudokuBoard board = SudokuBoard(
        solution: sampleSolution,
        puzzle: samplePuzzle,
      );

      List<(int, int)> empty = board.getEmptyCells();
      expect(empty.length, equals(3)); // We set 3 empty cells
      expect(empty.contains((0, 0)), equals(true));
      expect(empty.contains((0, 1)), equals(true));
      expect(empty.contains((1, 0)), equals(true));
    });

    test('isFilled returns correct state', () {
      SudokuBoard board = SudokuBoard(
        solution: sampleSolution,
        puzzle: samplePuzzle,
      );

      expect(board.isFilled(), equals(false));

      // Fill remaining cells
      board.setValue(0, 0, 5);
      board.setValue(0, 1, 3);
      board.setValue(1, 0, 6);

      expect(board.isFilled(), equals(true));
    });

    test('Board copy creates independent copy', () {
      SudokuBoard board = SudokuBoard(
        solution: sampleSolution,
        puzzle: samplePuzzle,
      );

      SudokuBoard copy = board.copy();
      copy.setValue(0, 0, 5);

      expect(board.getValue(0, 0), equals(0));
      expect(copy.getValue(0, 0), equals(5));
    });
  });
}
