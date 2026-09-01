import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_game/core/sudoku/sudoku_generator.dart';
import 'package:sudoku_game/core/sudoku/sudoku_solver.dart';
import 'package:sudoku_game/core/sudoku/sudoku_validator.dart';
import 'package:sudoku_game/core/sudoku/sudoku_difficulty.dart';

void main() {
  group('SudokuGenerator Tests', () {
    test('generateSolution creates valid complete board', () {
      List<List<int>> solution = SudokuGenerator.generateSolution();

      // Check all cells are filled
      for (int i = 0; i < 9; i++) {
        for (int j = 0; j < 9; j++) {
          expect(solution[i][j], greaterThanOrEqualTo(1));
          expect(solution[i][j], lessThanOrEqualTo(9));
        }
      }

      // Check it's a valid solution
      expect(SudokuValidator.isValidSolution(solution), equals(true));
    });

    test('generateSolution creates different solutions', () {
      List<List<int>> solution1 = SudokuGenerator.generateSolution();
      List<List<int>> solution2 = SudokuGenerator.generateSolution();

      // Very unlikely to generate identical solutions
      bool identical = true;
      for (int i = 0; i < 9; i++) {
        for (int j = 0; j < 9; j++) {
          if (solution1[i][j] != solution2[i][j]) {
            identical = false;
            break;
          }
        }
        if (!identical) break;
      }

      expect(identical, equals(false)); // Should be different
    });

    test('same stage seed produces the same puzzle and solution pair', () {
      final seed = SudokuGenerator.seedFor(SudokuDifficulty.easy, 1);
      final first = SudokuGenerator.generatePuzzleWithSolution(
        SudokuDifficulty.easy,
        seed: seed,
      );
      final second = SudokuGenerator.generatePuzzleWithSolution(
        SudokuDifficulty.easy,
        seed: seed,
      );

      expect(first.puzzle, equals(second.puzzle));
      expect(first.solution, equals(second.solution));
    });

    test('generatePuzzle creates puzzle with unique solution', () {
      List<List<int>> puzzle = SudokuGenerator.generatePuzzle(SudokuDifficulty.easy);

      // Count solutions
      int solutionCount = SudokuSolver.countSolutions(puzzle);

      expect(solutionCount, equals(1));
    });

    test('generated puzzle clues match its paired solution', () {
      final game = SudokuGenerator.generatePuzzleWithSolution(
        SudokuDifficulty.normal,
      );

      for (int row = 0; row < 9; row++) {
        for (int col = 0; col < 9; col++) {
          if (game.puzzle[row][col] != 0) {
            expect(game.puzzle[row][col], equals(game.solution[row][col]));
          }
        }
      }
    });

    test('generatePuzzle Easy has correct clue range', () {
      List<List<int>> puzzle = SudokuGenerator.generatePuzzle(SudokuDifficulty.easy);

      int clueCount = 0;
      for (int i = 0; i < 9; i++) {
        for (int j = 0; j < 9; j++) {
          if (puzzle[i][j] != 0) clueCount++;
        }
      }

      DifficultyConfig config = DifficultyConfig.getConfig(SudokuDifficulty.easy);
      expect(clueCount, greaterThanOrEqualTo(config.minClues));
      expect(clueCount, lessThanOrEqualTo(config.maxClues));
    });

    test('generatePuzzle Normal has correct clue range', () {
      List<List<int>> puzzle = SudokuGenerator.generatePuzzle(SudokuDifficulty.normal);

      int clueCount = 0;
      for (int i = 0; i < 9; i++) {
        for (int j = 0; j < 9; j++) {
          if (puzzle[i][j] != 0) clueCount++;
        }
      }

      DifficultyConfig config = DifficultyConfig.getConfig(SudokuDifficulty.normal);
      expect(clueCount, greaterThanOrEqualTo(config.minClues));
      expect(clueCount, lessThanOrEqualTo(config.maxClues));
    });

    test('generatePuzzle Hard has correct clue range', () {
      List<List<int>> puzzle = SudokuGenerator.generatePuzzle(SudokuDifficulty.hard);

      int clueCount = 0;
      for (int i = 0; i < 9; i++) {
        for (int j = 0; j < 9; j++) {
          if (puzzle[i][j] != 0) clueCount++;
        }
      }

      DifficultyConfig config = DifficultyConfig.getConfig(SudokuDifficulty.hard);
      expect(clueCount, greaterThanOrEqualTo(config.minClues));
      expect(clueCount, lessThanOrEqualTo(config.maxClues));
    });

    test('Easy puzzles have more clues than Hard', () {
      List<List<int>> easyPuzzle = SudokuGenerator.generatePuzzle(SudokuDifficulty.easy);
      List<List<int>> hardPuzzle = SudokuGenerator.generatePuzzle(SudokuDifficulty.hard);

      int easyClues = 0;
      int hardClues = 0;

      for (int i = 0; i < 9; i++) {
        for (int j = 0; j < 9; j++) {
          if (easyPuzzle[i][j] != 0) easyClues++;
          if (hardPuzzle[i][j] != 0) hardClues++;
        }
      }

      expect(easyClues, greaterThan(hardClues));
    });

    test('Multiple generated Easy puzzles all have unique solutions', () {
      const int testCount = 10;

      for (int i = 0; i < testCount; i++) {
        List<List<int>> puzzle = SudokuGenerator.generatePuzzle(SudokuDifficulty.easy);
        int solutionCount = SudokuSolver.countSolutions(puzzle);

        expect(
          solutionCount,
          equals(1),
          reason: 'Easy puzzle #$i does not have unique solution',
        );
      }
    });

    test('Multiple generated Normal puzzles all have unique solutions', () {
      const int testCount = 10;

      for (int i = 0; i < testCount; i++) {
        List<List<int>> puzzle = SudokuGenerator.generatePuzzle(SudokuDifficulty.normal);
        int solutionCount = SudokuSolver.countSolutions(puzzle);

        expect(
          solutionCount,
          equals(1),
          reason: 'Normal puzzle #$i does not have unique solution',
        );
      }
    });

    test('Multiple generated Hard puzzles all have unique solutions', () {
      const int testCount = 5; // Fewer tests as Hard is slower

      for (int i = 0; i < testCount; i++) {
        List<List<int>> puzzle = SudokuGenerator.generatePuzzle(SudokuDifficulty.hard);
        int solutionCount = SudokuSolver.countSolutions(puzzle);

        expect(
          solutionCount,
          equals(1),
          reason: 'Hard puzzle #$i does not have unique solution',
        );
      }
    });

    test('Puzzle respects original Sudoku rules', () {
      List<List<int>> puzzle = SudokuGenerator.generatePuzzle(SudokuDifficulty.normal);

      // Puzzle itself must be valid
      expect(SudokuValidator.isBoardValid(puzzle), equals(true));
    });
  });
}
