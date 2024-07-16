import 'package:barassage_app/core/core.dart';
import 'package:flutter/material.dart';

class ContactController extends StatelessWidget {
  const ContactController({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feature 2 contact'),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}
