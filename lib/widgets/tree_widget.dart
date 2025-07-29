import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:money_tree/models/tree_model.dart';

class TreeWidget extends StatefulWidget {
  final TreeModel tree;
  final VoidCallback? onShake;

  const TreeWidget({super.key, required this.tree, this.onShake});

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

  void _handleShake() {
    if (widget.onShake != null) {
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

  Widget _buildTree() {
    // 나무 레벨에 따라 SVG 파일 선택
    final treeLevel = widget.tree.level;
    final svgPath = 'assets/images/tree_$treeLevel.svg';

    return Container(
      width: 200,
      height: 200,
      child: SvgPicture.asset(
        svgPath,
        width: 200,
        height: 200,
        fit: BoxFit.contain,
      ),
    );
  }
}
