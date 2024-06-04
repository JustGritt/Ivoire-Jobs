import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RouteManager {
  final List<RouteBase> _routes = [];
  void addRoute(RouteBase route) {
    _routes.addAll([route]);
  }

  void addAll(List<RouteBase> routes) {
    _routes.addAll(routes);
  }

  List<RouteBase> get routes => _routes;

  List<RouteBase> get links => _routes;
}

class Nav {
  static void toNamed(
    BuildContext context,
    String url, {
    Object? arguments,
  }) =>
      context.goNamed(
        url,
        extra: arguments,
      );

  static void to(
    BuildContext context,
    String url, {
    Object? arguments,
    Object? result,
  }) {
    context.go(
      url,
      extra: arguments,
    );
  }

  static void close(BuildContext context, [Object? result]) {
    context.pop(result);
  }
}
