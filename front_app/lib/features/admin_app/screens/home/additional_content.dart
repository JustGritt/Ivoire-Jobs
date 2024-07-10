import 'package:flutter/material.dart';
import 'package:barassage_app/features/admin_app/utils/home_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class AdditionalContent extends StatelessWidget {
  final GlobalKey appsKey;

  const AdditionalContent({
    required this.appsKey,
  });

  Future<void> _launchURL() async {
    const downloadUrl = 'https://your-download-link.com';
    if (await canLaunch(downloadUrl)) {
      await launch(downloadUrl);
    } else {
      throw 'Could not launch $downloadUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 800;
    final double? containerHeight = isDesktop ? 700 : null;

    return Container(
      key: appsKey,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
      color: Color(0xFF0F2027).withOpacity(0.9),
      height: containerHeight,
      child: isDesktop
          ? Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left Side: Image
          Expanded(
            flex: 1,
            child: Image.asset(
              'assets/images/your-image.png', // Replace with your image asset
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 20),
          // Right Side: Text and Download Button
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Discutez librement',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Vos messages et appels personnels sont sécurisés grâce au chiffrement de bout en bout. '
                      'Personne d’autre que vous ne pourra lire ni écouter la personne qui se trouve à l’autre bout du fil. '
                      'Pas même WhatsApp !',
                  style: TextStyle(fontSize: 18, color: Colors.white70),
                ),
                const SizedBox(height: 20),
                OutlinedButton(
                  onPressed: _launchURL, // Add the URL launch function here
                  child: Text(
                    'En savoir plus',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                    side: const BorderSide(
                      color: Color(0xFF3CC8A2),
                      width: 2,
                    ),
                    foregroundColor: Colors.white, // Text color
                    backgroundColor: Colors.transparent, // Button background color
                    overlayColor:  Colors.blueAccent,
                  ),
                ),
              ],
            ),
          ),
        ],
      )
          : Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Top: Image
          Image.asset(
            'assets/images/your-image.png', // Replace with your image asset
            fit: BoxFit.contain,
            height: 200,
          ),
          const SizedBox(height: 20),
          // Bottom: Text and Download Button
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Discutez librement',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Vos messages et appels personnels sont sécurisés grâce au chiffrement de bout en bout. '
                    'Personne d’autre que vous ne pourra lire ni écouter la personne qui se trouve à l’autre bout du fil. '
                    'Pas même WhatsApp !',
                style: TextStyle(fontSize: 18, color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              OutlinedButton(
                onPressed: _launchURL, // Add the URL launch function here
                child: Text(
                  'En savoir plus',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                  side: const BorderSide(
                    color: Color(0xFF3CC8A2),
                    width: 2,
                  ),
                  foregroundColor: Colors.white, // Text color
                  backgroundColor: Colors.transparent, // Button background color
                  overlayColor: Colors.blueAccent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
