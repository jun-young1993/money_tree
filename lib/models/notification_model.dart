import 'package:flutter/material.dart';

class NotificationModel {
  final String id;
  final String title;
  final String content;
  final DateTime date;
  final int points;
  final bool isRead;
  final NotificationType type;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.points,
    this.isRead = false,
    required this.type,
  });

  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}일 전';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}시간 전';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}분 전';
    } else {
      return '방금 전';
    }
  }

  String get formattedFullDate {
    return '${date.year}년 ${date.month}월 ${date.day}일';
  }
}

enum NotificationType {
  reward, // 리워드 획득
  mission, // 미션 완료
  growth, // 성장 알림
  system, // 시스템 알림
  event, // 이벤트 알림
}

extension NotificationTypeExtension on NotificationType {
  String get displayName {
    switch (this) {
      case NotificationType.reward:
        return '리워드';
      case NotificationType.mission:
        return '미션';
      case NotificationType.growth:
        return '성장';
      case NotificationType.system:
        return '시스템';
      case NotificationType.event:
        return '이벤트';
    }
  }

  IconData get icon {
    switch (this) {
      case NotificationType.reward:
        return Icons.card_giftcard;
      case NotificationType.mission:
        return Icons.emoji_events;
      case NotificationType.growth:
        return Icons.trending_up;
      case NotificationType.system:
        return Icons.info;
      case NotificationType.event:
        return Icons.event;
    }
  }

  Color get color {
    switch (this) {
      case NotificationType.reward:
        return Colors.orange;
      case NotificationType.mission:
        return Colors.blue;
      case NotificationType.growth:
        return Colors.green;
      case NotificationType.system:
        return Colors.grey;
      case NotificationType.event:
        return Colors.purple;
    }
  }
}
