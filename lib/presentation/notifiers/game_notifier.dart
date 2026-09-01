import 'dart:async';

import 'package:flutter/foundation.dart';
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

  // Getters
  SudokuBoard get board => _board;
  SudokuDifficulty get difficulty => _difficulty;
  int get elapsedSeconds => _elapsedSeconds;
  int get totalStarLight => _totalStarLight;
  int get starLightBalance => _starLightBalance;
  PlayerStatistics get statistics => _statistics;

  /// Restores account-wide rewards and statistics when the app starts.
  Future<void> loadProgress() async {
    final progress = await _progressStore.load();
    _starLightBalance = progress.starLightBalance;
    _statistics = progress.statistics;
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

    notifyListeners();
  }

  /// 셀에 값 설정
  void setCellValue(int row, int col, int value) {
    if (value == 0) {
      _board.setValue(row, col, 0);
    } else if (value >= 1 && value <= 9) {
      _board.setValue(row, col, value);
    }
    notifyListeners();
  }

  /// 메모 추가
  void addMemo(int row, int col, int number) {
    _board.addMemo(row, col, number);
    notifyListeners();
  }

  /// 메모 제거
  void removeMemo(int row, int col, int number) {
    _board.removeMemo(row, col, number);
    notifyListeners();
  }

  /// 메모 모두 제거
  void clearMemo(int row, int col) {
    _board.clearMemo(row, col);
    notifyListeners();
  }

  /// 실행 취소 (한 단계 뒤로)
  void undo() {
    // TODO: 나중에 히스토리 구현
    notifyListeners();
  }

  /// 힌트 표시
  void showHint(int row, int col) {
    if (_board.playerBoard[row][col] == 0) {
      _board.setValue(row, col, _board.solution[row][col]);
      notifyListeners();
    }
  }

  /// 게임 일시 중지 (타이머 멈춤)
  bool _isPaused = false;
  bool get isPaused => _isPaused;

  void togglePause() {
    _isPaused = !_isPaused;
    notifyListeners();
  }

  /// 타이머 증가 (매초 호출)
  void incrementTimer() {
    if (!_isPaused && !isPuzzleComplete) {
      _elapsedSeconds++;
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
    notifyListeners();
  }

  /// 게임 완료시 점수 계산
  void completeGame() {
    if (_hasAwardedCurrentGame || !isPuzzleComplete) return;

    // 난이도별 StarLight 보상 (기본값)
    final config = DifficultyConfig.getConfig(_difficulty);
    _totalStarLight = config.starLightReward;
    _starLightBalance += _totalStarLight;
    _hasAwardedCurrentGame = true;
    _statistics = _statistics.recordCompletion(_difficulty, _elapsedSeconds);
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
}
