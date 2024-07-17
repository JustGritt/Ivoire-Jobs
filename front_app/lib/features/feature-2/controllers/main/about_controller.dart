import 'package:barassage_app/core/core.dart';
import 'package:flutter/material.dart';

class AboutController extends StatelessWidget {
  const AboutController({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feature 2 about'),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}
