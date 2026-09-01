import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_game/core/sudoku/sudoku_validator.dart';

void main() {
  group('SudokuValidator Tests', () {
    late List<List<int>> validBoard;
    late List<List<int>> invalidBoard;

    setUp(() {
      // Valid board with one empty cell
      validBoard = [
        [5, 3, 4, 6, 7, 8, 9, 1, 2],
        [6, 7, 2, 1, 9, 5, 3, 4, 8],
        [1, 9, 8, 3, 4, 2, 5, 6, 7],
        [8, 5, 9, 7, 6, 1, 4, 2, 3],
        [4, 2, 6, 8, 5, 3, 7, 9, 1],
        [7, 1, 3, 9, 2, 4, 8, 5, 6],
        [9, 6, 1, 5, 3, 7, 2, 8, 4],
        [2, 8, 7, 4, 1, 9, 6, 3, 5],
        [3, 4, 5, 2, 8, 6, 1, 7, 0], // Empty cell at [8][8]
      ];

      // Invalid board with duplicate in row
      invalidBoard = [
        [5, 5, 4, 6, 7, 8, 9, 1, 2], // Two 5s
        [6, 7, 2, 1, 9, 5, 3, 4, 8],
        [1, 9, 8, 3, 4, 2, 5, 6, 7],
        [8, 5, 9, 7, 6, 1, 4, 2, 3],
        [4, 2, 6, 8, 5, 3, 7, 9, 1],
        [7, 1, 3, 9, 2, 4, 8, 5, 6],
        [9, 6, 1, 5, 3, 7, 2, 8, 4],
        [2, 8, 7, 4, 1, 9, 6, 3, 5],
        [3, 4, 5, 2, 8, 6, 1, 7, 9],
      ];
    });

    test('isValidMove accepts valid placement', () {
      bool result = SudokuValidator.isValidMove(validBoard, 8, 8, 9);
      expect(result, equals(true));
    });

    test('isValidMove rejects invalid placement in row', () {
      bool result = SudokuValidator.isValidMove(validBoard, 0, 8, 5);
      expect(result, equals(false)); // 5 already in row
    });

    test('isValidMove rejects invalid placement in column', () {
      bool result = SudokuValidator.isValidMove(validBoard, 8, 0, 2);
      expect(result, equals(false)); // 2 already in column
    });

    test('isValidMove rejects invalid placement in block', () {
      bool result = SudokuValidator.isValidMove(validBoard, 8, 8, 1);
      expect(result, equals(false)); // 1 already in 3x3 block
    });

    test('isRowValid detects duplicate', () {
      bool result = SudokuValidator.isRowValid(invalidBoard, 0);
      expect(result, equals(false));
    });

    test('isRowValid accepts valid row', () {
      bool result = SudokuValidator.isRowValid(validBoard, 0);
      expect(result, equals(true));
    });

    test('isColumnValid accepts valid column', () {
      bool result = SudokuValidator.isColumnValid(validBoard, 0);
      expect(result, equals(true));
    });

    test('isBlockValid accepts valid block', () {
      bool result = SudokuValidator.isBlockValid(validBoard, 0, 0);
      expect(result, equals(true));
    });

    test('isBoardValid detects invalid board', () {
      bool result = SudokuValidator.isBoardValid(invalidBoard);
      expect(result, equals(false));
    });

    test('isBoardValid accepts valid board', () {
      bool result = SudokuValidator.isBoardValid(validBoard);
      expect(result, equals(true));
    });

    test('isPuzzleComplete detects incomplete board', () {
      bool result = SudokuValidator.isPuzzleComplete(
        validBoard,
        [
          [5, 3, 4, 6, 7, 8, 9, 1, 2],
          [6, 7, 2, 1, 9, 5, 3, 4, 8],
          [1, 9, 8, 3, 4, 2, 5, 6, 7],
          [8, 5, 9, 7, 6, 1, 4, 2, 3],
          [4, 2, 6, 8, 5, 3, 7, 9, 1],
          [7, 1, 3, 9, 2, 4, 8, 5, 6],
          [9, 6, 1, 5, 3, 7, 2, 8, 4],
          [2, 8, 7, 4, 1, 9, 6, 3, 5],
          [3, 4, 5, 2, 8, 6, 1, 7, 9],
        ],
      );
      expect(result, equals(false)); // validBoard has empty cell
    });

    test('isPuzzleComplete accepts complete matching board', () {
      List<List<int>> completedBoard = validBoard.map((row) => [...row]).toList();
      completedBoard[8][8] = 9;

      bool result = SudokuValidator.isPuzzleComplete(
        completedBoard,
        [
          [5, 3, 4, 6, 7, 8, 9, 1, 2],
          [6, 7, 2, 1, 9, 5, 3, 4, 8],
          [1, 9, 8, 3, 4, 2, 5, 6, 7],
          [8, 5, 9, 7, 6, 1, 4, 2, 3],
          [4, 2, 6, 8, 5, 3, 7, 9, 1],
          [7, 1, 3, 9, 2, 4, 8, 5, 6],
          [9, 6, 1, 5, 3, 7, 2, 8, 4],
          [2, 8, 7, 4, 1, 9, 6, 3, 5],
          [3, 4, 5, 2, 8, 6, 1, 7, 9],
        ],
      );
      expect(result, equals(true));
    });

    test('getInvalidCells finds wrong answers', () {
      List<List<int>> playerBoard = validBoard.map((row) => [...row]).toList();
      playerBoard[0][0] = 1; // Wrong answer
      playerBoard[8][8] = 9; // Complete it

      List<(int, int)> invalid = SudokuValidator.getInvalidCells(
        playerBoard,
        [
          [5, 3, 4, 6, 7, 8, 9, 1, 2],
          [6, 7, 2, 1, 9, 5, 3, 4, 8],
          [1, 9, 8, 3, 4, 2, 5, 6, 7],
          [8, 5, 9, 7, 6, 1, 4, 2, 3],
          [4, 2, 6, 8, 5, 3, 7, 9, 1],
          [7, 1, 3, 9, 2, 4, 8, 5, 6],
          [9, 6, 1, 5, 3, 7, 2, 8, 4],
          [2, 8, 7, 4, 1, 9, 6, 3, 5],
          [3, 4, 5, 2, 8, 6, 1, 7, 9],
        ],
      );

      expect(invalid.length, equals(1));
      expect(invalid.contains((0, 0)), equals(true));
    });

    test('isCellWrong detects wrong cell', () {
      List<List<int>> playerBoard = validBoard.map((row) => [...row]).toList();
      playerBoard[8][8] = 1; // Wrong answer

      bool result = SudokuValidator.isCellWrong(
        8,
        8,
        playerBoard,
        [
          [5, 3, 4, 6, 7, 8, 9, 1, 2],
          [6, 7, 2, 1, 9, 5, 3, 4, 8],
          [1, 9, 8, 3, 4, 2, 5, 6, 7],
          [8, 5, 9, 7, 6, 1, 4, 2, 3],
          [4, 2, 6, 8, 5, 3, 7, 9, 1],
          [7, 1, 3, 9, 2, 4, 8, 5, 6],
          [9, 6, 1, 5, 3, 7, 2, 8, 4],
          [2, 8, 7, 4, 1, 9, 6, 3, 5],
          [3, 4, 5, 2, 8, 6, 1, 7, 9],
        ],
      );
      expect(result, equals(true));
    });
  });
}
