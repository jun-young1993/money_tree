import 'package:flutter/material.dart';
import 'package:flutter_common/app_navigation.dart';
import 'package:flutter_common/widgets/fade_route.dart';

enum AppRoutes { main }

class AppPaths implements IPath<AppRoutes> {
  static const main = '/main';

  static const _path = {AppRoutes.main: main};

  @override
  String of(AppRoutes route) => _path[route] ?? '';

  FadeRoute onGenerateRoute(RouteSettings settings) {
    if (settings.name == null) {
      throw Exception('Route name is null');
    }

    switch (settings.name) {
      case AppPaths.main:
        return FadeRoute(page: Text('main'));
      default:
        return FadeRoute(page: Text('default'));
    }
  }
}
