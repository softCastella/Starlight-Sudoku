import 'package:sudoku_game/core/sudoku/sudoku_board.dart';
import 'package:sudoku_game/core/sudoku/sudoku_difficulty.dart';

/// Serializable state for an unfinished Sudoku puzzle.
class ActiveGameSnapshot {
  const ActiveGameSnapshot({
    required this.board,
    required this.difficulty,
    required this.elapsedSeconds,
    required this.isPaused,
    required this.hintsUsed,
    this.levelNumber = 1,
  });

  final SudokuBoard board;
  final SudokuDifficulty difficulty;
  final int elapsedSeconds;
  final bool isPaused;
  final int hintsUsed;
  final int levelNumber;

  Map<String, Object> toJson() => {
        'solution': board.solution,
        'puzzle': board.puzzle,
        'playerBoard': board.playerBoard,
        'memoCandidates': board.memoCandidates
            .map((row) => row.map((memo) => memo.toList()).toList())
            .toList(),
        'difficulty': difficulty.name,
        'elapsedSeconds': elapsedSeconds,
        'isPaused': isPaused,
        'hintsUsed': hintsUsed,
        'levelNumber': levelNumber,
      };

  factory ActiveGameSnapshot.fromJson(Map<String, dynamic> json) {
    List<List<int>> readBoard(String key) => (json[key] as List)
        .map((row) => (row as List).map((value) => value as int).toList())
        .toList();
    final memos = (json['memoCandidates'] as List)
        .map(
          (row) => (row as List)
              .map((memo) => (memo as List).cast<int>().toSet())
              .toList(),
        )
        .toList();

    return ActiveGameSnapshot(
      board: SudokuBoard(
        solution: readBoard('solution'),
        puzzle: readBoard('puzzle'),
        playerBoard: readBoard('playerBoard'),
        memoCandidates: memos,
      ),
      difficulty: SudokuDifficulty.values.byName(json['difficulty'] as String),
      elapsedSeconds: json['elapsedSeconds'] as int,
      isPaused: json['isPaused'] as bool,
      hintsUsed: json['hintsUsed'] as int? ?? 0,
      levelNumber: json['levelNumber'] as int? ?? 1,
    );
  }
}