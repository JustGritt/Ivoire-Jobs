import 'package:barassage_app/features/admin_app/utils/home_colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';

class AdditionalContent extends StatelessWidget {
  final GlobalKey appsKey;
  final String downloadUrl;

  const AdditionalContent({
    required this.appsKey,
    required this.downloadUrl,
  });

  Future<void> _launchURL() async {
    if (await canLaunch(downloadUrl)) {
      await launch(downloadUrl);
    } else {
      throw 'Could not launch $downloadUrl';
    }
  }

  String _extractVersionFromUrl(String url) {
    final regex = RegExp(r'v(\d+\.\d+\.\d+)\.apk');
    final match = regex.firstMatch(url);
    return match != null
        ? match.group(1) ?? 'Unknown version'
        : 'Unknown version';
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 800;
    final double? containerHeight = isDesktop ? 700 : null;
    final String version = _extractVersionFromUrl(downloadUrl);

    return Container(
      key: appsKey,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
      color: background,
      height: containerHeight,
      child: isDesktop
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      QrImageView(
                        data: downloadUrl,
                        size: 200.0,
                        backgroundColor: tertiary,
                      ),
                      const SizedBox(height: 40),
                      OutlinedButton(
                        onPressed: _launchURL,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Download',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.arrow_downward,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 14.0),
                          side: const BorderSide(
                            color: Color(0xFF3CC8A2),
                            width: 2,
                          ),
                          foregroundColor: tertiary,
                          backgroundColor: Colors.transparent,
                          overlayColor: tertiary,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Column(
                        children: [
                          Text(
                            'Minimum Requirements',
                            style: TextStyle(
                              color: tertiary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '(version $version)',
                            style: TextStyle(
                                color: tertiary.withOpacity(0.8), fontSize: 14),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Android OS 13.0 or higher',
                            style: TextStyle(
                                color: tertiary.withOpacity(0.8), fontSize: 14),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Unlimited Internet access subscription recommended',
                            style: TextStyle(
                                color: tertiary.withOpacity(0.8), fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Explore the app',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: tertiary,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'Your service is just a click away. Download the app now !',
                        style: TextStyle(fontSize: 18, color: tertiary),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'All your data is secured with end-to-end encryption.',
                        style: TextStyle(fontSize: 18, color: tertiary),
                      )
                    ],
                  ),
                ),
              ],
            )
          : Column(
              children: [
                Column(
                  children: [
                    Text(
                      'Explore the app',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: tertiary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Your service is just a click away. Download the app now !'
                      'All your data is secured with end-to-end encryption.',
                      style: TextStyle(fontSize: 18, color: tertiary),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(height: 60),
                QrImageView(
                  data: downloadUrl,
                  backgroundColor: tertiary,
                  size: 200.0,
                ),
                const SizedBox(height: 30),
                OutlinedButton(
                  onPressed: _launchURL,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Download',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.arrow_downward,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 14.0),
                    side: const BorderSide(
                      color: Color(0xFF3CC8A2),
                      width: 2,
                    ),
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.transparent,
                    overlayColor: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 40),
                Column(
                  children: [
                    Text(
                      'Minimum Requirements',
                      style: TextStyle(
                        color: tertiary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '(version $version)',
                      style: TextStyle(
                          color: tertiary.withOpacity(0.8), fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Android OS 13.0 or higher',
                      style: TextStyle(
                          color: tertiary.withOpacity(0.8), fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Unlimited Internet access subscription recommended',
                      style: TextStyle(
                          color: tertiary.withOpacity(0.8), fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
