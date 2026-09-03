import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:sudoku_game/core/config/game_balance.dart';
import 'package:sudoku_game/core/progress/active_game_snapshot.dart';
import 'package:sudoku_game/core/progress/player_statistics.dart';
import 'package:sudoku_game/core/progress/stage_progress.dart';
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
  static const int hintRewardPenalty = GameBalance.hintRewardPenalty;

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
  StageProgress _stageProgress = const StageProgress();
  ActiveGameSnapshot? _activeGame;
  final List<SudokuBoard> _undoHistory = [];
  final List<int> _undoMistakes = [];
  int _hintsUsed = 0;
  int _mistakesUsed = 0;
  int _lastMistakePenalty = 0;
  int _mistakeFlashId = 0;
  int _levelNumber = 1;
  bool _hasSeenOpeningStory = false;
  bool _hasSeenTrialEnd = false;

  // Getters
  SudokuBoard get board => _board;
  SudokuDifficulty get difficulty => _difficulty;
  int get elapsedSeconds => _elapsedSeconds;
  int get totalStarLight => _totalStarLight;
  int get starLightBalance => _starLightBalance;
  PlayerStatistics get statistics => _statistics;
  StageProgress get stageProgress => _stageProgress;
  int get currentLevel => _levelNumber;
  bool get hasActiveGame => _activeGame != null;
  bool get hasSeenOpeningStory => _hasSeenOpeningStory;
  bool get hasSeenTrialEnd => _hasSeenTrialEnd;
  bool get isTrialComplete =>
      GameBalance.isTrial &&
      _stageProgress.completedCount(SudokuDifficulty.easy) >=
          GameBalance.trialStageCount;
  bool get canUndo => _undoHistory.isNotEmpty;
  int get hintsUsed => _hintsUsed;
  int get hintsRemaining => maxHints - _hintsUsed;
  int get mistakesUsed => _mistakesUsed;
  int get lastMistakePenalty => _lastMistakePenalty;
  int get mistakeFlashId => _mistakeFlashId;
  bool get isFirstVillageComplete =>
      buildings.every((building) => building.isComplete);

  int get potentialStarLightReward {
    if (isCurrentLevelCleared) return 0;
    final config = DifficultyConfig.getConfig(_difficulty);
    return config.remainingStarLight(
      hintsUsed: _hintsUsed,
      mistakesUsed: _mistakesUsed,
    );
  }

  bool get isCurrentLevelCleared =>
      _stageProgress.isCompleted(_difficulty, _levelNumber);

  bool get hasNextLevel {
    final stageCount = DifficultyConfig.getConfig(_difficulty).stageCount;
    return _levelNumber < stageCount &&
        _stageProgress.isUnlocked(_difficulty, _levelNumber + 1);
  }

  int completedStageCount(SudokuDifficulty difficulty) =>
      _stageProgress.completedCount(difficulty);

  bool isStageUnlocked(SudokuDifficulty difficulty, int level) =>
      _stageProgress.isUnlocked(difficulty, level);

  bool isStageCompleted(SudokuDifficulty difficulty, int level) =>
      _stageProgress.isCompleted(difficulty, level);

  /// Restores account-wide rewards and statistics when the app starts.
  Future<void> loadProgress() async {
    final progress = await _progressStore.load();
    _starLightBalance = progress.starLightBalance;
    _statistics = progress.statistics;
    _stageProgress = progress.stageProgress;
    _hasSeenOpeningStory = progress.hasSeenOpeningStory;
    _hasSeenTrialEnd = progress.hasSeenTrialEnd;
    _activeGame = await _progressStore.loadActiveGame();
    notifyListeners();
  }

  Future<void> completeOpeningStory() async {
    if (_hasSeenOpeningStory) return;
    _hasSeenOpeningStory = true;
    notifyListeners();
    await _progressStore.saveHasSeenOpeningStory();
  }

  Future<void> markTrialEndSeen() async {
    if (_hasSeenTrialEnd) return;
    _hasSeenTrialEnd = true;
    notifyListeners();
    await _progressStore.saveHasSeenTrialEnd();
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

  /// 0 at night, 1 when every landmark in the first village is restored.
  double get villageDawn {
    final landmarks = buildings;
    final required = landmarks.fold<int>(0, (sum, b) => sum + b.requiredStarLight);
    final restored = landmarks.fold<int>(0, (sum, b) => sum + b.restoredStarLight);
    if (required == 0) return 0;
    return (restored / required).clamp(0.0, 1.0);
  }

  bool get isPuzzleComplete {
    if (!_board.isFilled()) return false;
    return SudokuValidator.isPuzzleComplete(_board.playerBoard, _board.solution);
  }

  List<(int, int)> get invalidCells {
    return SudokuValidator.getInvalidCells(_board.playerBoard, _board.solution);
  }

  /// 새로운 게임 시작
  void startNewGame(SudokuDifficulty difficulty, {int level = 1}) {
    _difficulty = difficulty;
    _levelNumber = level;
    final generatedGame = SudokuGenerator.generatePuzzleWithSolution(
      difficulty,
      seed: SudokuGenerator.seedFor(difficulty, level),
    );

    _board = SudokuBoard(
      solution: generatedGame.solution,
      puzzle: generatedGame.puzzle,
    );

    _elapsedSeconds = 0;
    _totalStarLight = 0;
    _hasAwardedCurrentGame = false;
    _isPaused = false;
    _hintsUsed = 0;
    _mistakesUsed = 0;
    _lastMistakePenalty = 0;
    _mistakeFlashId = 0;
    _undoHistory.clear();
    _undoMistakes.clear();
    _saveActiveGame();

    notifyListeners();
  }

  void startNextLevel() {
    if (!hasNextLevel) return;
    startNewGame(_difficulty, level: _levelNumber + 1);
  }

  /// Loads the unfinished puzzle saved on this device.
  bool continueGame() {
    final snapshot = _activeGame;
    if (snapshot == null) return false;

    _board = snapshot.board;
    _difficulty = snapshot.difficulty;
    _levelNumber = snapshot.levelNumber;
    _elapsedSeconds = snapshot.elapsedSeconds;
    _isPaused = snapshot.isPaused;
    _totalStarLight = 0;
    _hasAwardedCurrentGame = false;
    _hintsUsed = snapshot.hintsUsed;
    _mistakesUsed = snapshot.mistakesUsed;
    _lastMistakePenalty = 0;
    _mistakeFlashId = 0;
    _undoHistory.clear();
    _undoMistakes.clear();
    notifyListeners();
    return true;
  }

  /// 셀에 값 설정
  void setCellValue(int row, int col, int value) {
    if (value >= 1 && value <= 9 && _board.playerBoard[row][col] == value) {
      return;
    }
    _recordUndoState();
    if (value == 0) {
      _board.setValue(row, col, 0);
    } else if (value >= 1 && value <= 9) {
      final isWrong = value != _board.solution[row][col];
      _board.setValue(row, col, value);
      if (isWrong) {
        final penalty =
            DifficultyConfig.getConfig(_difficulty).mistakeStarLightPenalty;
        _mistakesUsed++;
        _lastMistakePenalty = penalty;
        _mistakeFlashId++;
      }
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
    _mistakesUsed = _undoMistakes.removeLast();
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
    _mistakesUsed = 0;
    _lastMistakePenalty = 0;
    _mistakeFlashId = 0;
    _undoHistory.clear();
    _undoMistakes.clear();
    _saveActiveGame();
    notifyListeners();
  }

  /// 게임 완료시 점수 계산
  void completeGame() {
    if (_hasAwardedCurrentGame || !isPuzzleComplete) return;

    final isFirstClear = !_stageProgress.isCompleted(_difficulty, _levelNumber);
    if (isFirstClear) {
      final config = DifficultyConfig.getConfig(_difficulty);
      _totalStarLight = config.remainingStarLight(
        hintsUsed: _hintsUsed,
        mistakesUsed: _mistakesUsed,
      );
      _starLightBalance += _totalStarLight;
      _stageProgress = _stageProgress.markCompleted(_difficulty, _levelNumber);
    } else {
      _totalStarLight = 0;
    }

    _hasAwardedCurrentGame = true;
    _statistics = _statistics.recordCompletion(_difficulty, _elapsedSeconds);
    _activeGame = null;
    unawaited(_progressStore.clearActiveGame());
    unawaited(
      _progressStore.save(
        starLightBalance: _starLightBalance,
        statistics: _statistics,
        stageProgress: _stageProgress,
      ),
    );

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
      mistakesUsed: _mistakesUsed,
      levelNumber: _levelNumber,
    );
    unawaited(_progressStore.saveActiveGame(_activeGame!));
  }

  void _recordUndoState() {
    if (_undoHistory.length == 100) {
      _undoHistory.removeAt(0);
      _undoMistakes.removeAt(0);
    }
    _undoHistory.add(_board.copy());
    _undoMistakes.add(_mistakesUsed);
  }
}
