import 'package:flutter/material.dart';
import 'package:flutter_common/flutter_common.dart';
import 'package:flutter_common/models/app-reward/point_transaction.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:money_tree/models/notification_model.dart';

class NotificationListScreen extends StatefulWidget {
  final User user;
  const NotificationListScreen({super.key, required this.user});

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  PointTransactionPagingBloc get pointTransactionPagingBloc =>
      context.read<PointTransactionPagingBloc>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    pointTransactionPagingBloc.close();
    super.dispose();
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
    return BlocBuilder<
      PointTransactionPagingBloc,
      PagingState<int, PointTransaction>
    >(
      bloc: pointTransactionPagingBloc,
      builder:
          (context, state) => PagedListView<int, PointTransaction>(
            state: state,
            fetchNextPage: () async {
              pointTransactionPagingBloc.add(FetchNextPointTransaction());
            },
            builderDelegate: PagedChildBuilderDelegate<PointTransaction>(
              itemBuilder:
                  (context, item, index) => _buildNotificationItem(item),
              firstPageProgressIndicatorBuilder:
                  (_) => CircularProgressIndicator(),
              newPageProgressIndicatorBuilder:
                  (_) => CircularProgressIndicator(),
              noItemsFoundIndicatorBuilder: (_) => _buildEmptyList(),
              noMoreItemsIndicatorBuilder:
                  (_) => Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      Tr.message.lastNotice.tr(),
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
            ),
          ),
    );
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
