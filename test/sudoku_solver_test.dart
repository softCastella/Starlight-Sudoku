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
  });
}
