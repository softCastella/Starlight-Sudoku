import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_game/core/sudoku/sudoku_difficulty.dart';
import 'package:sudoku_game/core/sudoku/sudoku_generator.dart';
import 'package:sudoku_game/core/sudoku/sudoku_solver.dart';
import 'package:sudoku_game/core/sudoku/sudoku_validator.dart';

void main() {
  group('Sudoku generation integration', () {
    for (final difficulty in SudokuDifficulty.values) {
      test('${difficulty.name} puzzles keep every generation invariant', () {
        for (var attempt = 0; attempt < 5; attempt++) {
          final game = SudokuGenerator.generatePuzzleWithSolution(difficulty);
          final config = DifficultyConfig.getConfig(difficulty);
          var clueCount = 0;

          expect(
            SudokuValidator.isValidSolution(game.solution),
            isTrue,
            reason: '${difficulty.name} solution $attempt is invalid',
          );
          expect(
            SudokuValidator.isBoardValid(game.puzzle),
            isTrue,
            reason: '${difficulty.name} puzzle $attempt has a conflict',
          );

          for (var row = 0; row < 9; row++) {
            for (var col = 0; col < 9; col++) {
              final clue = game.puzzle[row][col];
              if (clue != 0) {
                clueCount++;
                expect(clue, game.solution[row][col]);
              }
            }
          }

          expect(clueCount, inInclusiveRange(config.minClues, config.maxClues));
          expect(SudokuSolver.countSolutions(game.puzzle), 1);
          expect(SudokuSolver.solve(game.puzzle), equals(game.solution));
        }
      });
    }
  });
}