import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_game/core/sudoku/sudoku_solver.dart';
import 'package:sudoku_game/core/sudoku/sudoku_validator.dart';

void main() {
  group('SudokuSolver Tests', () {
    late List<List<int>> easyPuzzle;

    setUp(() {
      // Simple puzzle with clear unique solution
      easyPuzzle = [
        [5, 3, 0, 0, 7, 0, 0, 0, 0],
        [6, 0, 0, 1, 9, 5, 0, 0, 0],
        [0, 9, 8, 0, 0, 0, 0, 6, 0],
        [8, 0, 0, 0, 6, 0, 0, 0, 3],
        [4, 0, 0, 8, 0, 3, 0, 0, 1],
        [7, 0, 0, 0, 2, 0, 0, 0, 6],
        [0, 6, 0, 0, 0, 0, 2, 8, 0],
        [0, 0, 0, 4, 1, 9, 0, 0, 5],
        [0, 0, 0, 0, 8, 0, 0, 7, 9],
      ];
    });

    test('solve returns valid solution', () {
      List<List<int>>? solution = SudokuSolver.solve(easyPuzzle);

      expect(solution, isNotNull);
      if (solution != null) {
        expect(SudokuValidator.isValidSolution(solution), equals(true));
      }
    });

    test('solve respects given numbers', () {
      List<List<int>>? solution = SudokuSolver.solve(easyPuzzle);

      expect(solution, isNotNull);
      if (solution != null) {
        // Check that given numbers are preserved
        expect(solution[0][0], equals(5));
        expect(solution[0][1], equals(3));
        expect(solution[1][0], equals(6));
      }
    });

    test('countSolutions finds unique solution', () {
      int solutionCount = SudokuSolver.countSolutions(easyPuzzle);
      expect(solutionCount, equals(1));
    });

    test('invalid completed board has no solution', () {
      final invalidCompleted = [
        [5, 5, 4, 6, 7, 8, 9, 1, 2],
        [6, 7, 2, 1, 9, 5, 3, 4, 8],
        [1, 9, 8, 3, 4, 2, 5, 6, 7],
        [8, 5, 9, 7, 6, 1, 4, 2, 3],
        [4, 2, 6, 8, 5, 3, 7, 9, 1],
        [7, 1, 3, 9, 2, 4, 8, 5, 6],
        [9, 6, 1, 5, 3, 7, 2, 8, 4],
        [2, 8, 7, 4, 1, 9, 6, 3, 5],
        [3, 4, 5, 2, 8, 6, 1, 7, 9],
      ];

      expect(SudokuSolver.solve(invalidCompleted), isNull);
      expect(SudokuSolver.countSolutions(invalidCompleted), 0);
    });
  });
}
