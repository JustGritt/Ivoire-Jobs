import 'package:flutter/material.dart';

class AppContext {
  final navigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

  BuildContext get navigatorContext => navigatorKey.currentState!.context;
}
