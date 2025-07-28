import 'package:flutter/material.dart';
import 'package:flutter_common/models/app-reward/point_transaction.dart';

class TreeWidget extends StatefulWidget {
  final List<PointTransaction>? transactions;
  final VoidCallback? onShake;
  final bool isShaking;

  const TreeWidget({
    super.key,
    this.transactions,
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
    _shakeController.forward().then((_) {
      _shakeController.reverse();
    });
    widget.onShake!();
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
    final treeStages = [
      _buildSeed(),
      _buildSprout(),
      _buildSmallTree(),
      _buildGrowingTree(),
      _buildBigTree(),
    ];

    return treeStages[widget.transactions?.length ?? 0];
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
