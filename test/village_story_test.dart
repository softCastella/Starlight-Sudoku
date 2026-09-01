import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_game/core/village/opening_story.dart';
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

  test('opening story explains night, windows, and morning', () {
    expect(OpeningStoryPage.pages, hasLength(3));
    expect(OpeningStoryPage.pages.first.headline, '잠든 마을');
    expect(OpeningStoryPage.pages[1].body, contains('창문'));
    expect(OpeningStoryPage.pages.last.dawn, greaterThan(0.5));
  });
}