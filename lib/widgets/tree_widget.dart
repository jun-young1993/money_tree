import 'package:flutter/material.dart';
import 'package:flutter_common/models/app-reward/point_transaction.dart';
import 'package:flutter_common/models/user/user.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TreeWidget extends StatefulWidget {
  final UserReward? userRewards;
  final User user;
  final VoidCallback? onShake;

  const TreeWidget({
    super.key,
    required this.userRewards,
    required this.user,
    this.onShake,
  });

  @override
  State<TreeWidget> createState() => _TreeWidgetState();
}

class _TreeWidgetState extends State<TreeWidget> with TickerProviderStateMixin {
  late AnimationController _shakeController;
  late AnimationController _growthController;
  late Animation<double> _shakeAnimation;
  late Animation<double> _growthAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _growthController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _shakeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticOut),
    );

    _growthAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _growthController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _growthController.dispose();
    super.dispose();
  }

  bool _isMaxLevel() {
    final limit = _getTreeSvgPath().length - 1;
    final userRewardLength = widget.userRewards?.usageCount ?? 0;
    if (userRewardLength >= limit) {
      return true;
    }
    return false;
  }

  void _handleShake() {
    if (widget.onShake != null && !_isMaxLevel()) {
      _shakeController.forward().then((_) {
        _shakeController.reverse();
      });
      widget.onShake!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleShake,
      child: AnimatedBuilder(
        animation: Listenable.merge([_shakeAnimation, _growthAnimation]),
        builder: (context, child) {
          return Transform.scale(
            scale: _growthAnimation.value,
            child: Transform.rotate(
              angle: _shakeAnimation.value * 0.1,
              child: _buildTree(),
            ),
          );
        },
      ),
    );
  }

  List<String> _getTreeSvgPath() {
    return [
      'assets/images/tree_1.svg',
      'assets/images/tree_2.svg',
      'assets/images/tree_3.svg',
      'assets/images/tree_4.svg',
      'assets/images/tree_5.svg',
    ];
  }

  int _getTreeLevel() {
    final userRewardLength = widget.userRewards?.usageCount ?? 0;

    final treeSvgPath = _getTreeSvgPath();
    int treeLevel = treeSvgPath.length - 1;
    if (userRewardLength < treeSvgPath.length) {
      treeLevel = userRewardLength;
    }
    return treeLevel;
  }

  Widget _buildTree() {
    // 나무 레벨에 따라 SVG 파일 선택
    final treeLevel = _getTreeLevel();
    final treeSvgPath = _getTreeSvgPath();

    final svgPath = treeSvgPath[treeLevel];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 나무 레벨 표시
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green[400]!, Colors.green[600]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.3),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.eco, color: Colors.white, size: 16),
              SizedBox(width: 4),
              Text(
                'Level ${treeLevel + 1}',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        // 나무 단계 이름 표시
        Text(
          _getTreeStageName(treeLevel),
          style: TextStyle(
            color: Colors.green[700],
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 8),
        // 나무 이미지
        SizedBox(
          width: 200,
          height: 200,
          child: SvgPicture.asset(
            svgPath,
            width: 200,
            height: 200,
            fit: BoxFit.contain,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            _getRandomMessage(treeLevel),
            style: TextStyle(
              color: Colors.green[700],
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
            // maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (_isMaxLevel())
          Text(
            '🌳 최고 레벨에 도달했습니다!',
            style: TextStyle(
              color: Colors.green[700],
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
      ],
    );
  }

  String _getTreeStageName(int level) {
    switch (level) {
      case 0:
        return '🌱 씨앗';
      case 1:
        return '🌿 새싹';
      case 2:
        return '🌳 작은 나무';
      case 3:
        return '🌲 성장 나무';
      case 4:
        return '🌴 큰 나무';
      default:
        return '🌳 완성된 나무';
    }
  }

  String _getRandomMessage(int level) {
    final messages = _getLevelMessages(level);
    final randomIndex = DateTime.now().millisecond % messages.length;
    return messages[randomIndex];
  }

  List<String> _getLevelMessages(int level) {
    switch (level) {
      case 0: // 씨앗
        return [
          '🌱 씨앗을 터치해서 포인트를 받으세요!',
          '🌱 작은 씨앗에서 포인트가 자라나요!',
          '🌱 씨앗을 흔들어서 포인트를 모으세요!',
          '🌱 씨앗을 터치하고 포인트를 획득하세요!',
          '🌱 씨앗에서 특별한 포인트를 받으세요!',
        ];
      case 1: // 새싹
        return [
          '🌿 새싹을 터치해서 포인트를 받으세요!',
          '🌿 새싹이 자라면서 포인트도 자라나요!',
          '🌿 새싹을 흔들어서 포인트를 모으세요!',
          '🌿 새싹을 터치하고 포인트를 획득하세요!',
          '🌿 새싹에서 행운의 포인트를 받으세요!',
        ];
      case 2: // 작은 나무
        return [
          '🌳 작은 나무를 터치해서 포인트를 받으세요!',
          '🌳 작은 나무에서 포인트가 열려요!',
          '🌳 작은 나무를 흔들어서 포인트를 모으세요!',
          '🌳 작은 나무를 터치하고 포인트를 획득하세요!',
          '🌳 작은 나무에서 특별한 포인트를 받으세요!',
        ];
      case 3: // 성장 나무
        return [
          '🌲 성장한 나무를 터치해서 포인트를 받으세요!',
          '🌲 성장한 나무에서 많은 포인트가 열려요!',
          '🌲 성장한 나무를 흔들어서 포인트를 모으세요!',
          '🌲 성장한 나무를 터치하고 포인트를 획득하세요!',
          '🌲 성장한 나무에서 귀중한 포인트를 받으세요!',
        ];
      case 4: // 큰 나무
        return [
          '🌴 큰 나무를 터치해서 포인트를 받으세요!',
          '🌴 큰 나무에서 풍성한 포인트가 열려요!',
          '🌴 큰 나무를 흔들어서 포인트를 모으세요!',
          '🌴 큰 나무를 터치하고 포인트를 획득하세요!',
          '🌴 큰 나무에서 최고급 포인트를 받으세요!',
        ];
      default: // 완성된 나무
        return [
          '🌳 완성된 나무를 터치해서 포인트를 받으세요!',
          '🌳 완성된 나무에서 최고의 포인트가 열려요!',
          '🌳 완성된 나무를 흔들어서 포인트를 모으세요!',
          '🌳 완성된 나무를 터치하고 포인트를 획득하세요!',
          '🌳 완성된 나무에서 전설의 포인트를 받으세요!',
        ];
    }
  }
}
