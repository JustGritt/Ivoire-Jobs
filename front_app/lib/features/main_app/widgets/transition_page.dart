import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformTransitionPage {
  const PlatformTransitionPage({required this.child});
  final Widget child;

  Page<dynamic> show(BuildContext context) {
    if (Theme.of(context).platform == TargetPlatform.android) {
      return MaterialPage(child: child);
    }
    return CupertinoPage(child: child);
  }
}
