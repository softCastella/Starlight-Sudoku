import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:sudoku_game/core/progress/active_game_snapshot.dart';
import 'package:sudoku_game/core/progress/player_statistics.dart';
import 'package:sudoku_game/core/sudoku/sudoku_board.dart';
import 'package:sudoku_game/core/sudoku/sudoku_difficulty.dart';
import 'package:sudoku_game/core/sudoku/sudoku_generator.dart';
import 'package:sudoku_game/core/sudoku/sudoku_validator.dart';
import 'package:sudoku_game/core/village/building_progress.dart';
import 'package:sudoku_game/data/local/game_progress_store.dart';

/// 게임 상태를 관리하는 ChangeNotifier
/// Core 엔진과 UI를 연결하는 브릿지 역할
class GameNotifier extends ChangeNotifier {
  static const maxHints = 3;
  static const hintRewardPenalty = 10;

  GameNotifier({GameProgressStore? progressStore})
      : _progressStore = progressStore ?? GameProgressStore();

  final GameProgressStore _progressStore;
  late SudokuBoard _board;
  late SudokuDifficulty _difficulty;
  late int _elapsedSeconds = 0;
  late int _totalStarLight = 0;
  int _starLightBalance = 0;
  bool _hasAwardedCurrentGame = false;
  PlayerStatistics _statistics = const PlayerStatistics();
  ActiveGameSnapshot? _activeGame;
  final List<SudokuBoard> _undoHistory = [];
  int _hintsUsed = 0;

  // Getters
  SudokuBoard get board => _board;
  SudokuDifficulty get difficulty => _difficulty;
  int get elapsedSeconds => _elapsedSeconds;
  int get totalStarLight => _totalStarLight;
  int get starLightBalance => _starLightBalance;
  PlayerStatistics get statistics => _statistics;
  bool get hasActiveGame => _activeGame != null;
  bool get canUndo => _undoHistory.isNotEmpty;
  int get hintsUsed => _hintsUsed;
  int get hintsRemaining => maxHints - _hintsUsed;
  bool get isFirstVillageComplete =>
      buildings.every((building) => building.isComplete);

  int get potentialStarLightReward {
    final reward = DifficultyConfig.getConfig(_difficulty).starLightReward;
    return (reward - (_hintsUsed * hintRewardPenalty)).clamp(0, reward);
  }

  /// Restores account-wide rewards and statistics when the app starts.
  Future<void> loadProgress() async {
    final progress = await _progressStore.load();
    _starLightBalance = progress.starLightBalance;
    _statistics = progress.statistics;
    _activeGame = await _progressStore.loadActiveGame();
    notifyListeners();
  }

  List<BuildingProgress> get buildings {
    const definitions = [
      (id: 'bakery', name: '빵집', iconName: 'bakery', cost: 160),
      (id: 'library', name: '도서관', iconName: 'library', cost: 300),
      (id: 'fountain', name: '분수 광장', iconName: 'fountain', cost: 540),
    ];
    var available = _starLightBalance;

    return definitions.map((definition) {
      final restored = available.clamp(0, definition.cost);
      available = (available - definition.cost).clamp(0, available);
      return BuildingProgress(
        id: definition.id,
        name: definition.name,
        iconName: definition.iconName,
        requiredStarLight: definition.cost,
        restoredStarLight: restored,
      );
    }).toList();
  }

  bool get isPuzzleComplete {
    if (!_board.isFilled()) return false;
    return SudokuValidator.isPuzzleComplete(_board.playerBoard, _board.solution);
  }

  List<(int, int)> get invalidCells {
    return SudokuValidator.getInvalidCells(_board.playerBoard, _board.solution);
  }

  /// 새로운 게임 시작
  void startNewGame(SudokuDifficulty difficulty) {
    _difficulty = difficulty;
    final generatedGame = SudokuGenerator.generatePuzzleWithSolution(difficulty);

    _board = SudokuBoard(
      solution: generatedGame.solution,
      puzzle: generatedGame.puzzle,
    );

    _elapsedSeconds = 0;
    _totalStarLight = 0;
    _hasAwardedCurrentGame = false;
    _isPaused = false;
    _hintsUsed = 0;
    _undoHistory.clear();
    _saveActiveGame();

    notifyListeners();
  }

  /// Loads the unfinished puzzle saved on this device.
  bool continueGame() {
    final snapshot = _activeGame;
    if (snapshot == null) return false;

    _board = snapshot.board;
    _difficulty = snapshot.difficulty;
    _elapsedSeconds = snapshot.elapsedSeconds;
    _isPaused = snapshot.isPaused;
    _totalStarLight = 0;
    _hasAwardedCurrentGame = false;
    _hintsUsed = snapshot.hintsUsed;
    _undoHistory.clear();
    notifyListeners();
    return true;
  }

  /// 셀에 값 설정
  void setCellValue(int row, int col, int value) {
    _recordUndoState();
    if (value == 0) {
      _board.setValue(row, col, 0);
    } else if (value >= 1 && value <= 9) {
      _board.setValue(row, col, value);
    }
    _saveActiveGame();
    notifyListeners();
  }

  /// Fills the current puzzle with its solution for debug UI verification.
  void completePuzzleForDebug() {
    for (var row = 0; row < 9; row++) {
      for (var col = 0; col < 9; col++) {
        if (!_board.isFixedCell(row, col)) {
          _board.setValue(row, col, _board.solution[row][col]);
        }
      }
    }
    notifyListeners();
  }

  /// 메모 추가
  void addMemo(int row, int col, int number) {
    _recordUndoState();
    _board.addMemo(row, col, number);
    _saveActiveGame();
    notifyListeners();
  }

  /// 메모 제거
  void removeMemo(int row, int col, int number) {
    _recordUndoState();
    _board.removeMemo(row, col, number);
    _saveActiveGame();
    notifyListeners();
  }

  /// 메모 모두 제거
  void clearMemo(int row, int col) {
    _recordUndoState();
    _board.clearMemo(row, col);
    _saveActiveGame();
    notifyListeners();
  }

  /// 실행 취소 (한 단계 뒤로)
  void undo() {
    if (_undoHistory.isEmpty) return;

    _board = _undoHistory.removeLast();
    _saveActiveGame();
    notifyListeners();
  }

  /// 힌트 표시
  bool showHint(int row, int col) {
    if (_hintsUsed >= maxHints || _board.playerBoard[row][col] != 0) {
      return false;
    }

    _recordUndoState();
    _board.setValue(row, col, _board.solution[row][col]);
    _hintsUsed++;
    _saveActiveGame();
    notifyListeners();
    return true;
  }

  /// 게임 일시 중지 (타이머 멈춤)
  bool _isPaused = false;
  bool get isPaused => _isPaused;

  void togglePause() {
    _isPaused = !_isPaused;
    _saveActiveGame();
    notifyListeners();
  }

  /// 타이머 증가 (매초 호출)
  void incrementTimer() {
    if (!_isPaused && !isPuzzleComplete) {
      _elapsedSeconds++;
      _saveActiveGame();
      notifyListeners();
    }
  }

  /// 게임 포기 (리셋)
  void giveUp() {
    _board = SudokuBoard(
      solution: _board.solution,
      puzzle: _board.puzzle,
    );
    _elapsedSeconds = 0;
    _totalStarLight = 0;
    _isPaused = false;
    _hintsUsed = 0;
    _undoHistory.clear();
    _saveActiveGame();
    notifyListeners();
  }

  /// 게임 완료시 점수 계산
  void completeGame() {
    if (_hasAwardedCurrentGame || !isPuzzleComplete) return;

    // 난이도별 StarLight 보상 (기본값)
    _totalStarLight = potentialStarLightReward;
    _starLightBalance += _totalStarLight;
    _hasAwardedCurrentGame = true;
    _statistics = _statistics.recordCompletion(_difficulty, _elapsedSeconds);
    _activeGame = null;
    unawaited(_progressStore.clearActiveGame());
    unawaited(
      _progressStore.save(
        starLightBalance: _starLightBalance,
        statistics: _statistics,
      ),
    );

    // 시간 보너스 (선택사항)
    // 빠를수록 더 많은 보너스

    notifyListeners();
  }

  /// 게임 상태 리셋
  void reset() {
    _elapsedSeconds = 0;
    _totalStarLight = 0;
    _isPaused = false;
  }

  void _saveActiveGame() {
    _activeGame = ActiveGameSnapshot(
      board: _board.copy(),
      difficulty: _difficulty,
      elapsedSeconds: _elapsedSeconds,
      isPaused: _isPaused,
      hintsUsed: _hintsUsed,
    );
    unawaited(_progressStore.saveActiveGame(_activeGame!));
  }

  void _recordUndoState() {
    if (_undoHistory.length == 100) {
      _undoHistory.removeAt(0);
    }
    _undoHistory.add(_board.copy());
  }
}
