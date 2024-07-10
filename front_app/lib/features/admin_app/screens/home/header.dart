import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:barassage_app/features/admin_app/utils/responsive_utils.dart';

class Header extends StatelessWidget {
  final Function(GlobalKey?) scrollToSection;
  final GlobalKey aboutUsKey;
  final GlobalKey appsKey;
  final GlobalKey faqKey;
  final String downloadUrl; // Add the download URL here

  const Header({
    required this.scrollToSection,
    required this.aboutUsKey,
    required this.appsKey,
    required this.faqKey,
    required this.downloadUrl, // Add the download URL here
  });

  Future<void> _launchURL() async {
    if (await canLaunch(downloadUrl)) {
      await launch(downloadUrl);
    } else {
      throw 'Could not launch $downloadUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            'images/app-logo.png', // Add your logo here
            height: 72,
          ),
          if (isMobile(context))
            Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.menu, color: Colors.black87),
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                );
              },
            )
          else
            Row(
              children: [
                TextButton(
                  onPressed: () => scrollToSection(aboutUsKey),
                  child: Text('About Us',
                      style: TextStyle(color: Colors.black87.withOpacity(0.7), fontSize: 18)),
                ),
                TextButton(
                  onPressed: () => scrollToSection(appsKey),
                  child: Text('Apps',
                      style: TextStyle(color: Colors.black87.withOpacity(0.7), fontSize: 18)),
                ),
                TextButton(
                  onPressed: () => scrollToSection(faqKey),
                  child: Text('FAQ',
                      style: TextStyle(color: Colors.black87.withOpacity(0.7), fontSize: 18)),
                ),
                //add padding
                const SizedBox(width: 24),
                OutlinedButton(
                  onPressed: _launchURL, // Add the URL launch function here
                  child: Text(
                    'Download App',
                    style: TextStyle(color: Colors.black87, fontSize: 18),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                    side: const BorderSide(
                      color: Colors.blueAccent,
                      width: 2,
                    ),
                    foregroundColor: Colors.white, // Text color
                    backgroundColor: Colors.transparent, // Button background color
                    overlayColor:  Colors.blueAccent, // Splash color
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
