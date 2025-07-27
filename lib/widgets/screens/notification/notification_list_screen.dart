import 'package:flutter/material.dart';
import 'package:flutter_common/flutter_common.dart';
import 'package:flutter_common/models/app-reward/point_transaction.dart';

import 'package:money_tree/models/notification_model.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({super.key});

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  AppRewardBloc get appRewardBloc => context.read<AppRewardBloc>();

  final List<NotificationModel> _notifications = [];

  @override
  void initState() {
    super.initState();
    appRewardBloc.add(const AppRewardEvent.getPointTransactions());
  }

  List<NotificationModel> _generateSampleNotifications() {
    return [
      NotificationModel(
        id: '1',
        title: '나무 흔들기 포인트 획득',
        content: '나무를 흔들어서 25포인트를 획득했습니다.',
        date: DateTime.now().subtract(Duration(minutes: 5)),
        points: 25,
        type: NotificationType.reward,
      ),
      NotificationModel(
        id: '2',
        title: '친구 초대 미션 완료',
        content: '친구를 초대하여 50포인트를 획득했습니다.',
        date: DateTime.now().subtract(Duration(hours: 2)),
        points: 50,
        type: NotificationType.mission,
      ),
      NotificationModel(
        id: '3',
        title: '나무 성장 축하!',
        content: '축하합니다! 나무가 새싹으로 성장했습니다.',
        date: DateTime.now().subtract(Duration(hours: 5)),
        points: 100,
        type: NotificationType.growth,
      ),
      NotificationModel(
        id: '4',
        title: '스타벅스 아메리카노 교환',
        content: '200포인트를 사용하여 스타벅스 아메리카노를 교환했습니다.',
        date: DateTime.now().subtract(Duration(days: 1)),
        points: -200,
        type: NotificationType.reward,
      ),
      NotificationModel(
        id: '5',
        title: '리뷰 작성 미션 완료',
        content: '앱 리뷰를 작성하여 30포인트를 획득했습니다.',
        date: DateTime.now().subtract(Duration(days: 1)),
        points: 30,
        type: NotificationType.mission,
      ),
      NotificationModel(
        id: '6',
        title: '시스템 점검 안내',
        content: '오늘 밤 12시부터 2시간 동안 시스템 점검이 예정되어 있습니다.',
        date: DateTime.now().subtract(Duration(days: 2)),
        points: 0,
        type: NotificationType.system,
      ),
      NotificationModel(
        id: '7',
        title: '여름 이벤트 시작',
        content: '여름 한정 이벤트가 시작되었습니다. 특별한 리워드를 확인해보세요!',
        date: DateTime.now().subtract(Duration(days: 3)),
        points: 0,
        type: NotificationType.event,
      ),
      NotificationModel(
        id: '8',
        title: '일일 로그인 보상',
        content: '오늘도 로그인하여 10포인트를 획득했습니다.',
        date: DateTime.now().subtract(Duration(days: 3)),
        points: 10,
        type: NotificationType.reward,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          '알림 내역',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.green[600],
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green[600]!, Colors.green[700]!],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
              icon: Icon(Icons.filter_list, color: Colors.white, size: 20),
              onPressed: () {
                // 필터 기능 추가 예정
              },
            ),
          ),
        ],
      ),
      body: AppRewardLoadingSelector((isLoading) {
        return isLoading
            ? Center(
              child: Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.green[600]!,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      '알림을 불러오는 중...',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            )
            : _buildNotificationList();
      }),
    );
  }

  Widget _buildEmptyList() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                Icons.notifications_none,
                size: 48,
                color: Colors.grey[400],
              ),
            ),
            SizedBox(height: 20),
            Text(
              '알림이 없습니다',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey[700],
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '새로운 알림이 오면 여기에 표시됩니다',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationList() {
    return AppRewardPointTransactionsSelector((pointTransactions) {
      if (pointTransactions == null || pointTransactions.isEmpty) {
        return _buildEmptyList();
      }

      // 날짜별로 그룹화
      Map<String, List<PointTransaction>> groupedTransactions = {};
      for (var transaction in pointTransactions) {
        String dateKey = _formatDate(transaction.createdAt);
        if (!groupedTransactions.containsKey(dateKey)) {
          groupedTransactions[dateKey] = [];
        }
        groupedTransactions[dateKey]!.add(transaction);
      }

      return ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: groupedTransactions.length,
        itemBuilder: (context, index) {
          String dateKey = groupedTransactions.keys.elementAt(index);
          List<PointTransaction> transactions = groupedTransactions[dateKey]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 날짜 헤더

              // 해당 날짜의 알림들
              ...transactions.map(
                (transaction) => _buildNotificationItem(transaction),
              ),
              SizedBox(height: 16),
            ],
          );
        },
      );
    });
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(Duration(days: 1));
    final transactionDate = DateTime(date.year, date.month, date.day);

    if (transactionDate == today) {
      return '오늘';
    } else if (transactionDate == yesterday) {
      return '어제';
    } else {
      return '${date.year}년 ${date.month}월 ${date.day}일';
    }
  }

  Widget _buildNotificationItem(PointTransaction pointTransaction) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [Colors.white, Colors.grey[50]!],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 10,
            offset: Offset(0, 4),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 20,
            offset: Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1), width: 1),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: pointTransaction.source.color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: pointTransaction.source.color.withOpacity(0.2),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            pointTransaction.source.icon,
            color: pointTransaction.source.color,
            size: 24,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                pointTransaction.description ?? '',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(width: 8),
            // 포인트 표시
            if (pointTransaction.amount != 0)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      pointTransaction.transactionType.color.withOpacity(0.2),
                      pointTransaction.transactionType.color.withOpacity(0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: pointTransaction.transactionType.color.withOpacity(
                      0.3,
                    ),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: pointTransaction.transactionType.color.withOpacity(
                        0.1,
                      ),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.monetization_on,
                      size: 16,
                      color: pointTransaction.transactionType.color,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '${pointTransaction.amount > 0 ? '+' : ''}${pointTransaction.amount}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: pointTransaction.transactionType.color,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Text(
              '누적 포인트: ${pointTransaction.balanceAfter.toString()}P',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            SizedBox(height: 8),
            Text(
              pointTransaction.createdAt.toLocal().toString(),
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
          ],
        ),
        onTap: () {
          // _showNotificationDetail(notification);
        },
      ),
    );
  }
}
