enum TreeStage {
  seed, // 씨앗
  sprout, // 새싹
  smallTree, // 작은 나무
  growingTree, // 성장 나무
  bigTree, // 큰나무
}

class TreeModel {
  final TreeStage stage;
  final int currentPoints;
  final int pointsToNextStage;
  final int totalEarnedPoints;
  final int level;
  final String username;
  final DateTime lastShakeTime;
  final int shakeCount;

  const TreeModel({
    required this.stage,
    required this.currentPoints,
    required this.pointsToNextStage,
    required this.totalEarnedPoints,
    required this.level,
    required this.username,
    required this.lastShakeTime,
    required this.shakeCount,
  });

  TreeModel copyWith({
    TreeStage? stage,
    int? currentPoints,
    int? pointsToNextStage,
    int? totalEarnedPoints,
    int? level,
    String? username,
    DateTime? lastShakeTime,
    int? shakeCount,
  }) {
    return TreeModel(
      stage: stage ?? this.stage,
      currentPoints: currentPoints ?? this.currentPoints,
      pointsToNextStage: pointsToNextStage ?? this.pointsToNextStage,
      totalEarnedPoints: totalEarnedPoints ?? this.totalEarnedPoints,
      level: level ?? this.level,
      username: username ?? this.username,
      lastShakeTime: lastShakeTime ?? this.lastShakeTime,
      shakeCount: shakeCount ?? this.shakeCount,
    );
  }

  double get progressToNextStage {
    if (pointsToNextStage == 0) return 1.0;
    return (currentPoints / pointsToNextStage).clamp(0.0, 1.0);
  }

  bool get canShake {
    final now = DateTime.now();
    final timeSinceLastShake = now.difference(lastShakeTime);
    return timeSinceLastShake.inMinutes >= 30; // 30분마다 흔들기 가능
  }

  int get pointsFromShake {
    return 10 + (level * 5); // 레벨에 따라 흔들기 포인트 증가
  }

  String get stageName {
    switch (stage) {
      case TreeStage.seed:
        return '씨앗';
      case TreeStage.sprout:
        return '새싹';
      case TreeStage.smallTree:
        return '작은 나무';
      case TreeStage.growingTree:
        return '성장 나무';
      case TreeStage.bigTree:
        return '큰나무';
    }
  }

  String get stageDescription {
    switch (stage) {
      case TreeStage.seed:
        return '작은 씨앗이에요. 포인트를 모아서 새싹으로 성장시켜보세요!';
      case TreeStage.sprout:
        return '새싹이 자라나고 있어요. 더 많은 포인트로 작은 나무로 성장할 수 있어요!';
      case TreeStage.smallTree:
        return '작은 나무가 되었어요! 계속 포인트를 모으면 더 큰 나무가 될 거예요.';
      case TreeStage.growingTree:
        return '나무가 잘 자라고 있어요! 조금만 더 하면 큰나무가 될 수 있어요.';
      case TreeStage.bigTree:
        return '훌륭한 큰나무가 되었어요! 계속 포인트를 모아서 더 성장시켜보세요!';
    }
  }

  int get nextStagePoints {
    switch (stage) {
      case TreeStage.seed:
        return 100;
      case TreeStage.sprout:
        return 300;
      case TreeStage.smallTree:
        return 600;
      case TreeStage.growingTree:
        return 1000;
      case TreeStage.bigTree:
        return 2000;
    }
  }
}
