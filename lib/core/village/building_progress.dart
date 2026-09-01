/// Immutable restoration state for one village building.
class BuildingProgress {
  const BuildingProgress({
    required this.id,
    required this.name,
    required this.iconName,
    required this.requiredStarLight,
    required this.restoredStarLight,
  });

  final String id;
  final String name;
  final String iconName;
  final int requiredStarLight;
  final int restoredStarLight;

  int get level => (restoredStarLight * 5 ~/ requiredStarLight).clamp(0, 5);
  double get progress => restoredStarLight / requiredStarLight;
  bool get isComplete => restoredStarLight >= requiredStarLight;
  int get remainingStarLight => requiredStarLight - restoredStarLight;
}