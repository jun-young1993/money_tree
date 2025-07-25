import 'package:flutter/material.dart';
import 'package:money_tree/models/tree_model.dart';

class TreeWidget extends StatefulWidget {
  final TreeModel tree;
  final VoidCallback? onShake;
  final bool isShaking;

  const TreeWidget({
    super.key,
    required this.tree,
    this.onShake,
    this.isShaking = false,
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
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _shakeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticOut),
    );

    _growthAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _growthController, curve: Curves.easeInOut),
    );

    _growthController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _growthController.dispose();
    super.dispose();
  }

  void _handleShake() {
    if (widget.tree.canShake && widget.onShake != null) {
      _shakeController.forward().then((_) {
        _shakeController.reverse();
      });
      widget.onShake!();
    } else if (!widget.tree.canShake) {
      _showShakeCooldownDialog();
    }
  }

  void _showShakeCooldownDialog() {
    final timeSinceLastShake = DateTime.now().difference(
      widget.tree.lastShakeTime,
    );
    final remainingMinutes = 30 - timeSinceLastShake.inMinutes;

    // SnackBar로 알림 메시지 표시
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.timer, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                '$remainingMinutes분 후에 다시 시도해보세요.',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.orange[600],
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    // 기존 다이얼로그도 유지
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('잠시만요!'),
            content: Text(
              '나무를 흔들 수 있는 시간이 아직이에요.\n$remainingMinutes분 후에 다시 시도해보세요.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('확인'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleShake,
      child: AnimatedBuilder(
        animation: Listenable.merge([_shakeAnimation, _growthAnimation]),
        builder: (context, child) {
          return Transform.rotate(
            angle: _shakeAnimation.value * 0.1 * (widget.isShaking ? 1 : 0),
            child: Transform.scale(
              scale: _growthAnimation.value,
              child: _buildTree(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTree() {
    switch (widget.tree.stage) {
      case TreeStage.seed:
        return _buildSeed();
      case TreeStage.sprout:
        return _buildSprout();
      case TreeStage.smallTree:
        return _buildSmallTree();
      case TreeStage.growingTree:
        return _buildGrowingTree();
      case TreeStage.bigTree:
        return _buildBigTree();
    }
  }

  Widget _buildSeed() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.brown[400],
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.brown.withOpacity(0.3),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Icon(Icons.grain, color: Colors.brown[800], size: 30),
        ),
        SizedBox(height: 20),
        Container(
          width: 120,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.brown[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              '씨앗',
              style: TextStyle(
                color: Colors.brown[800],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSprout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.green[400],
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.3),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Icon(Icons.eco, color: Colors.green[800], size: 40),
        ),
        SizedBox(height: 20),
        Container(
          width: 120,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.green[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              '새싹',
              style: TextStyle(
                color: Colors.green[800],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSmallTree() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 100,
          height: 120,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 나무 줄기
              Positioned(
                bottom: 0,
                child: Container(
                  width: 20,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.brown[600],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              // 나뭇잎
              Positioned(
                top: 20,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.green[500],
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        Container(
          width: 120,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.green[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              '작은 나무',
              style: TextStyle(
                color: Colors.green[800],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGrowingTree() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 120,
          height: 150,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 나무 줄기
              Positioned(
                bottom: 0,
                child: Container(
                  width: 25,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.brown[600],
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              // 나뭇잎
              Positioned(
                top: 30,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.green[600],
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
              // 작은 나뭇잎
              Positioned(
                top: 20,
                left: 20,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.green[400],
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        Container(
          width: 120,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.green[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              '성장 나무',
              style: TextStyle(
                color: Colors.green[800],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBigTree() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 150,
          height: 180,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 나무 줄기
              Positioned(
                bottom: 0,
                child: Container(
                  width: 30,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.brown[700],
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              // 큰 나뭇잎
              Positioned(
                top: 40,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.green[700],
                    borderRadius: BorderRadius.circular(60),
                  ),
                ),
              ),
              // 작은 나뭇잎들
              Positioned(
                top: 30,
                left: 30,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.green[500],
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
              Positioned(
                top: 20,
                right: 30,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.green[400],
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        Container(
          width: 120,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.green[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              '큰나무',
              style: TextStyle(
                color: Colors.green[800],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
