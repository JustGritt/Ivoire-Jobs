import 'package:flutter/material.dart';

class AdditionalContent extends StatelessWidget {
  final GlobalKey appsKey;

  const AdditionalContent({
    required this.appsKey,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          key: appsKey,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
          child: const Text(
            'Apps Section',
            style: TextStyle(fontSize: 36, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
