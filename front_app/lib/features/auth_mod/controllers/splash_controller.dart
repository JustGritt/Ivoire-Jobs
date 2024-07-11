import 'package:flutter/material.dart';

class SplashController extends StatelessWidget {
  const SplashController({super.key});

  @override
  Widget build(BuildContext context) {
    return Title(
      title: 'Splash Section',
      color: Colors.blue,
      child: const SplashController(),
    );
  }
}
