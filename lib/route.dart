import 'package:flutter/material.dart';
import 'package:flutter_common/app_navigation.dart';
import 'package:flutter_common/models/user/user.dart';
import 'package:flutter_common/state/user/user_selector.dart';
import 'package:flutter_common/widgets/fade_route.dart';
import 'package:money_tree/widgets/screens/home/home_screen.dart';
import 'package:money_tree/widgets/screens/notification/notification_list_screen.dart';
import 'package:money_tree/widgets/screens/exchange/exchange_screen.dart';

enum AppRoutes { main, notification, exchange }

class AppPaths implements IPath<AppRoutes> {
  static const main = '/main';
  static const notification = '/notification';
  static const exchange = '/exchange';

  static const _path = {
    AppRoutes.main: main,
    AppRoutes.notification: notification,
    AppRoutes.exchange: exchange,
  };

  @override
  String of(AppRoutes route) => _path[route] ?? '';

  FadeRoute onGenerateRoute(RouteSettings settings) {
    if (settings.name == null) {
      throw Exception('Route name is null');
    }

    switch (settings.name) {
      case AppPaths.main:
        return FadeRoute(
          page: UserInfoSelector((user) {
            if (user == null) {
              return const CircularProgressIndicator();
            }
            return HomeScreen(user: user);
          }),
        );
      case AppPaths.notification:
        return FadeRoute(
          page: UserInfoSelector((user) {
            if (user == null) {
              return const CircularProgressIndicator();
            }
            return NotificationListScreen(user: user);
          }),
        );
      case AppPaths.exchange:
        return FadeRoute(
          page: UserInfoSelector((user) {
            if (user == null) {
              return const CircularProgressIndicator();
            }
            return const ExchangeScreen();
          }),
        );
      default:
        return FadeRoute(page: Text('default'));
    }
  }
}
