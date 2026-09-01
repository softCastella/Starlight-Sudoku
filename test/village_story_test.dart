import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_game/core/village/village_story.dart';

void main() {
  test('each village building has restoration story content', () {
    for (final buildingId in ['bakery', 'library', 'fountain']) {
      final story = VillageStory.forBuilding(buildingId);

      expect(story.buildingId, buildingId);
      expect(story.headline, isNotEmpty);
      expect(story.description, isNotEmpty);
      expect(story.completedDescription, isNotEmpty);
    }
  });
}