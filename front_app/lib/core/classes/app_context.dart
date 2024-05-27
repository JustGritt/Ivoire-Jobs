import 'package:flutter/material.dart';


class AppContext {
  final navigatorKey = GlobalKey<NavigatorState>();

  BuildContext get navigatorContext => navigatorKey.currentState!.context;
}