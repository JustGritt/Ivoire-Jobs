import 'package:flutter/material.dart';

class HeroScreen extends StatelessWidget {
  final GlobalKey aboutUsKey;
  final int columns;

  const HeroScreen({
    required this.aboutUsKey,
    required this.columns,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: aboutUsKey,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
      child: Column(
        children: [
          const Text(
            'ABOUT US',
            style: TextStyle(fontSize: 18, color: Colors.blueAccent),
          ),
          const SizedBox(height: 10),
          const Text(
            'Build Powerful Apps Effortlessly',
            style: TextStyle(
                fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          const Text(
            'Easily build beautiful apps, connect data, and implement advanced functionality. '
                'Create your app in just a few hours, with an attractive design and a smooth experience.',
            style: TextStyle(fontSize: 18, color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Wrap(
            alignment: WrapAlignment.spaceAround,
            runSpacing: 20,
            spacing: 20,
            children: [
              _buildStatisticCard('235', 'Days of hard work to bring Flutterviz to life!', columns),
              _buildStatisticCard('100+', 'more than 200 demo screen to start your project', columns),
              _buildStatisticCard('50+', 'Get all the standard Flutter widgets you\'ll need', columns),
            ],
          ),
          const SizedBox(height: 60),
          const Text(
            'OUR STORY',
            style: TextStyle(fontSize: 18, color: Colors.blueAccent),
          ),
          const SizedBox(height: 10),
          const Text(
            'We\'re just getting started',
            style: TextStyle(
                fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          const Text(
            'We already help over 4000+ companies achieve remarkable results.',
            style: TextStyle(fontSize: 18, color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Aliqua id fugiat nostrud irure ex duis ea quis id quis ad et. Sunt qui esse pariatur duis deserunt mollit dolore cillum minim tempor enim. Elit aute irure tempor cupidatat incididunt sint deserunt ut voluptate aute id deserunt nisi. Aliqua id fugiat nostrud irure ex duis ea quis id quis ad et. Sunt qui esse pariatur duis deserunt mollit dolore cillum minim tempor enim.',
              style: TextStyle(fontSize: 16, color: Colors.white70),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticCard(String title, String subtitle, int columns) {
    double width;
    if (columns == 3) {
      width = 250;
    } else if (columns == 2) {
      width = 200;
    } else {
      width = double.infinity;
    }

    return Container(
      width: width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 14, color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
