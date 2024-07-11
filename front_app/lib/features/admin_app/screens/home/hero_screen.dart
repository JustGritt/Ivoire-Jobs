import 'package:flutter/material.dart';
import 'package:barassage_app/features/admin_app/utils/home_colors.dart'; // Import the custom colors

class HeroScreen extends StatelessWidget {
  final GlobalKey aboutUsKey;
  final int columns;

  const HeroScreen({
    required this.aboutUsKey,
    required this.columns,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 800;
    final double? containerHeight = isDesktop ? 700 : null;

    return Container(
      key: aboutUsKey,
      padding:  EdgeInsets.symmetric(
        horizontal: 20,
        vertical: isDesktop ? 110 : 40,
      ),
      color: tertiary,
      height: containerHeight,
      width: double.infinity,
      child: Column(
        children: [
          if (isDesktop)
            const SizedBox(height: 10),
          Text(
            'ABOUT US',
            style: TextStyle(
              fontSize: isDesktop ? 24 : 16,
              fontWeight: FontWeight.bold,
              color: primary,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Find your perfect Service near you !',
            style: TextStyle(
              fontSize: isDesktop ? 48 : 32,
              fontWeight: FontWeight.bold,
              color: primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            'Easily find the best service providers near you. '
                'We have a wide range of services to choose from. ',
            style: TextStyle(
              fontSize: isDesktop ? 18 : 16,
              color: primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Wrap(
            alignment: WrapAlignment.spaceAround,
            runSpacing: 20,
            spacing: 20,
            children: [
              _buildStatisticCard(
                  '235+', 'Monthly user that using our app!', columns),
              _buildStatisticCard(
                  '100+', 'More than 100 services available', columns),
              _buildStatisticCard(
                  '10+', 'Available in 10 countries', columns),
            ],
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: primary, width: 1.3),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: secondary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 14,
              color: primary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
