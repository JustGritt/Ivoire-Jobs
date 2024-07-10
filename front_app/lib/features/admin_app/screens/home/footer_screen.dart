import 'package:flutter/material.dart';

class FooterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {},
                child: Text('Privacy & Terms',
                    style: TextStyle(color: Colors.black87.withOpacity(0.7))),
              ),
              const SizedBox(width: 4),
              TextButton(
                onPressed: () {},
                child: Text('Contact Us',
                    style: TextStyle(color: Colors.black87.withOpacity(0.7))),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text('© 2024 Barassage Inc.',
              style: TextStyle(color: Colors.black87.withOpacity(0.5)),
          ),
        ],
      ),
    );
  }
}
