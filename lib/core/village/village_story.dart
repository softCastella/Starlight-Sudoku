/// Narrative content unlocked as village landmarks are restored.
class VillageStory {
  const VillageStory({
    required this.buildingId,
    required this.headline,
    required this.description,
    required this.completedDescription,
  });

  final String buildingId;
  final String headline;
  final String description;
  final String completedDescription;

  static const _stories = {
    'bakery': VillageStory(
      buildingId: 'bakery',
      headline: '첫 번째 따뜻한 불빛',
      description: '오래된 빵집의 오븐은 별빛을 기다리고 있습니다.',
      completedDescription: '오븐에 불이 들어왔습니다. 골목에 갓 구운 빵 향기가 퍼집니다.',
    ),
    'library': VillageStory(
      buildingId: 'library',
      headline: '잠든 이야기들',
      description: '먼지 쌓인 도서관의 책들은 다시 읽히기를 기다립니다.',
      completedDescription: '책장에 불빛이 켜졌습니다. 마을의 이야기가 다시 이어집니다.',
    ),
    'fountain': VillageStory(
      buildingId: 'fountain',
      headline: '광장으로 돌아온 노래',
      description: '마른 분수 광장에 사람들의 웃음이 돌아올 날이 멀지 않았습니다.',
      completedDescription: '분수가 다시 흐르기 시작했습니다. 마을의 중심이 환하게 빛납니다.',
    ),
  };

  static VillageStory forBuilding(String buildingId) => _stories[buildingId]!;
}