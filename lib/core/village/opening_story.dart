/// First-run story that explains night, windows, and morning.
class OpeningStoryPage {
  const OpeningStoryPage({
    required this.headline,
    required this.body,
    required this.dawn,
  });

  final String headline;
  final String body;
  final double dawn;

  static const pages = [
    OpeningStoryPage(
      headline: '잠든 마을',
      body: '별빛 마을은 오래도록 밤이었습니다.\n창문은 꺼지고, 골목도 조용했습니다.',
      dawn: 0,
    ),
    OpeningStoryPage(
      headline: '창문의 불빛',
      body: '퍼즐 한 판이 창문 하나입니다.\n칸을 채울 때마다 마을에 작은 불이 들어옵니다.',
      dawn: 0.42,
    ),
    OpeningStoryPage(
      headline: '아침이 오면',
      body: '별빛이 모이면 하늘이 밝아집니다.\n잠든 빵집과 도서관, 분수 광장이 다시 깨어납니다.',
      dawn: 1,
    ),
  ];
}
