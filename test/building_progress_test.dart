import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_game/core/village/building_progress.dart';

void main() {
  test('building progress reports five restoration levels', () {
    const building = BuildingProgress(
      id: 'bakery',
      name: '빵집',
      iconName: 'bakery',
      requiredStarLight: 100,
      restoredStarLight: 60,
    );

    expect(building.level, 3);
    expect(building.progress, 0.6);
    expect(building.remainingStarLight, 40);
    expect(building.isComplete, isFalse);
  });
}