import 'package:flutter/material.dart';
import 'package:flutter_common/flutter_common.dart';
import 'package:money_tree/models/tree_model.dart';
import 'package:money_tree/widgets/tree_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TreeModel _tree;
  bool _isShaking = false;

  @override
  void initState() {
    super.initState();
    _initializeTree();
  }

  void _initializeTree() {
    _tree = TreeModel(
      stage: TreeStage.smallTree,
      currentPoints: 1250,
      pointsToNextStage: 600,
      totalEarnedPoints: 3200,
      level: 3,
      username: "사용자",
      lastShakeTime: DateTime.now().subtract(Duration(minutes: 45)),
      shakeCount: 15,
    );
  }

  void _handleTreeShake() {
    if (_tree.canShake) {
      setState(() {
        _isShaking = true;
        _tree = _tree.copyWith(
          currentPoints: _tree.currentPoints + _tree.pointsFromShake,
          totalEarnedPoints: _tree.totalEarnedPoints + _tree.pointsFromShake,
          lastShakeTime: DateTime.now(),
          shakeCount: _tree.shakeCount + 1,
        );
      });

      // 성장 체크
      _checkGrowth();

      // 흔들기 효과 종료
      Future.delayed(Duration(milliseconds: 500), () {
        setState(() {
          _isShaking = false;
        });
      });

      // SnackBar로 성공 메시지 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.eco, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  '나무를 흔들어서 ${_tree.pointsFromShake}포인트를 획득했어요!',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green[600],
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

      // 포인트 획득 알림 (기존 다이얼로그는 유지)
      _showPointsEarnedDialog(_tree.pointsFromShake);
    }
  }

  void _checkGrowth() {
    TreeStage newStage = _tree.stage;

    if (_tree.currentPoints >= _tree.nextStagePoints) {
      switch (_tree.stage) {
        case TreeStage.seed:
          newStage = TreeStage.sprout;
          break;
        case TreeStage.sprout:
          newStage = TreeStage.smallTree;
          break;
        case TreeStage.smallTree:
          newStage = TreeStage.growingTree;
          break;
        case TreeStage.growingTree:
          newStage = TreeStage.bigTree;
          break;
        case TreeStage.bigTree:
          // 이미 최대 단계
          break;
      }

      if (newStage != _tree.stage) {
        setState(() {
          _tree = _tree.copyWith(stage: newStage, level: _tree.level + 1);
        });

        // 성장 시에도 SnackBar로 성공 메시지 표시
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.trending_up, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '축하해요! 나무가 ${_tree.stageName}로 성장했어요!',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.orange[600],
            duration: Duration(seconds: 4),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );

        _showGrowthDialog();
      }
    }
  }

  void _showPointsEarnedDialog(int points) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Row(
              children: [
                Icon(Icons.eco, color: Colors.green),
                SizedBox(width: 8),
                Text('포인트 획득!'),
              ],
            ),
            content: Text('나무를 흔들어서 $points포인트를 획득했어요!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('확인'),
              ),
            ],
          ),
    );
  }

  void _showGrowthDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Row(
              children: [
                Icon(Icons.trending_up, color: Colors.green),
                SizedBox(width: 8),
                Text('성장!'),
              ],
            ),
            content: Text('축하해요! 나무가 ${_tree.stageName}로 성장했어요!'),
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
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // 상단 앱바
            SliverAppBar(
              expandedHeight: 100,
              floating: false,
              pinned: true,
              backgroundColor: Colors.green[600],
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  '돈나무',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.green[600]!, Colors.green[400]!],
                    ),
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.notifications, color: Colors.white),
                  onPressed: () {
                    // 알림 화면으로 이동
                  },
                ),
                IconButton(
                  icon: Icon(Icons.person, color: Colors.white),
                  onPressed: () {
                    // 프로필 화면으로 이동
                  },
                ),
              ],
            ),

            // 나무 섹션
            SliverToBoxAdapter(
              child: Container(
                height: 400,
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.blue[100]!, Colors.green[100]!],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // 사용자 정보
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '안녕하세요, ${_tree.username}님!',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green[600],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Lv.${_tree.level}',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    // 나무 위젯
                    Expanded(
                      child: Center(
                        child: TreeWidget(
                          tree: _tree,
                          onShake: _handleTreeShake,
                          isShaking: _isShaking,
                        ),
                      ),
                    ),

                    // 흔들기 안내
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _tree.canShake
                            ? '나무를 터치해서 흔들어보세요!'
                            : '30분마다 나무를 흔들 수 있어요',
                        style: TextStyle(
                          color: Colors.green[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 포인트 정보
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '현재 포인트',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '${_tree.currentPoints} P',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[600],
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '총 획득 포인트',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '${_tree.totalEarnedPoints} P',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    // 성장 진행률
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '다음 단계까지',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              '${_tree.currentPoints}/${_tree.nextStagePoints} P',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[600],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: _tree.progressToNextStage,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.green,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          _tree.stageDescription,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // 빠른 액션 버튼들
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: _QuickActionButton(
                        icon: Icons.card_giftcard,
                        title: '리워드',
                        color: Colors.orange,
                        onTap: () {
                          // 리워드 화면으로 이동
                        },
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _QuickActionButton(
                        icon: Icons.emoji_events,
                        title: '미션',
                        color: Colors.blue,
                        onTap: () {
                          // 미션 화면으로 이동
                        },
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _QuickActionButton(
                        icon: Icons.history,
                        title: '내역',
                        color: Colors.purple,
                        onTap: () {
                          // 내역 화면으로 이동
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 오늘의 미션
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '오늘의 미션',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    _MissionCard(
                      title: '나무 흔들기',
                      description: '나무를 흔들어서 포인트 획득하기',
                      points: _tree.pointsFromShake,
                      isCompleted: false,
                      progress: 0.0,
                    ),
                    SizedBox(height: 8),
                    _MissionCard(
                      title: '친구 초대하기',
                      description: '친구를 초대하고 50포인트 획득',
                      points: 50,
                      isCompleted: false,
                      progress: 0.0,
                    ),
                    SizedBox(height: 8),
                    _MissionCard(
                      title: '리뷰 작성하기',
                      description: '앱 리뷰를 작성하고 30포인트 획득',
                      points: 30,
                      isCompleted: false,
                      progress: 0.0,
                    ),
                  ],
                ),
              ),
            ),

            // 최근 활동
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '최근 활동',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    _ActivityItem(
                      title: '나무 흔들기',
                      description: '${_tree.pointsFromShake}포인트 획득',
                      time: '방금 전',
                      points: _tree.pointsFromShake,
                    ),
                    _ActivityItem(
                      title: '스타벅스 아메리카노 교환',
                      description: '200포인트 사용',
                      time: '2시간 전',
                      points: -200,
                    ),
                    _ActivityItem(
                      title: '친구 초대',
                      description: '김철수님 초대로 50포인트 획득',
                      time: '어제',
                      points: 50,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

class _MissionCard extends StatelessWidget {
  final String title;
  final String description;
  final int points;
  final bool isCompleted;
  final double progress;

  const _MissionCard({
    required this.title,
    required this.description,
    required this.points,
    required this.isCompleted,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: isCompleted ? Colors.green : Colors.grey[300],
              borderRadius: BorderRadius.circular(25),
            ),
            child: Icon(
              isCompleted ? Icons.check : Icons.emoji_events,
              color: isCompleted ? Colors.white : Colors.grey[600],
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                SizedBox(height: 8),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isCompleted ? Colors.green : Colors.blue,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 16),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isCompleted ? Colors.green : Colors.blue,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '+$points P',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final String title;
  final String description;
  final String time;
  final int points;

  const _ActivityItem({
    required this.title,
    required this.description,
    required this.time,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[300]!, width: 1)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: points > 0 ? Colors.green[100] : Colors.red[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              points > 0 ? Icons.add : Icons.remove,
              color: points > 0 ? Colors.green[600] : Colors.red[600],
              size: 20,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${points > 0 ? '+' : ''}$points P',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: points > 0 ? Colors.green[600] : Colors.red[600],
                ),
              ),
              SizedBox(height: 2),
              Text(
                time,
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
