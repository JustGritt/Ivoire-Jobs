import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:barassage_app/features/admin_app/utils/responsive_utils.dart';
import 'package:barassage_app/features/admin_app/utils/home_colors.dart'; // Import the custom colors

class Header extends StatefulWidget {
  final Function(GlobalKey?) scrollToSection;
  final GlobalKey aboutUsKey;
  final GlobalKey appsKey;
  final GlobalKey faqKey;
  final String downloadUrl;
  final double scrollOffset;

  const Header({
    required this.scrollToSection,
    required this.aboutUsKey,
    required this.appsKey,
    required this.faqKey,
    required this.downloadUrl,
    required this.scrollOffset,
  });

  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 950),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 1.4, end: -1.4).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _launchURL() async {
    if (await canLaunch(widget.downloadUrl)) {
      await launch(widget.downloadUrl);
    } else {
      throw 'Could not launch ${widget.downloadUrl}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 800;
    final bool isScrolled = widget.scrollOffset > 80.0;
    final Color backgroundColor = isScrolled ? Color(0xFFFBFBF7) : tertiary;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      color: backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                'assets/images/app-logo.png',
                height: isDesktop ? 72 : 52,
              ),
              SizedBox(width: isDesktop ? 10 : 4),
              Text(
                'Barassage',
                style: TextStyle(
                  color: primary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (isMobile(context))
            Flexible(
              child: OutlinedButton(
                onPressed: _launchURL,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Download',
                      style: TextStyle(color: primary, fontSize: 14),
                    ),
                    const SizedBox(width: 8),
                    AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _animation.value),
                          child: child,
                        );
                      },
                      child: Icon(
                        Icons.download, // Use the download icon
                        color: primary,
                        size: 18,
                      ),
                    ),
                  ],
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 20.0),
                  side: BorderSide(
                    color: secondary,
                    width: 2,
                  ),
                  foregroundColor: primary, // Text color
                  backgroundColor: Colors.transparent, // Button background color
                  overlayColor: primary,
                ),
              ),
            )
          else
            Row(
              children: [
                TextButton(
                  onPressed: () => widget.scrollToSection(widget.aboutUsKey),
                  child: Text(
                    'About Us',
                    style: TextStyle(
                      color: primary.withOpacity(0.9),
                      fontSize: 18,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => widget.scrollToSection(widget.appsKey),
                  child: Text(
                    'Apps',
                    style: TextStyle(
                      color: primary.withOpacity(0.9),
                      fontSize: 18,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => widget.scrollToSection(widget.faqKey),
                  child: Text(
                    'FAQ',
                    style: TextStyle(
                      color: primary.withOpacity(0.9),
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                OutlinedButton(
                  onPressed: _launchURL,
                  child: Row(
                    children: [
                      Text(
                        'Download',
                        style: TextStyle(color: primary, fontSize: 18),
                      ),
                      const SizedBox(width: 8),
                      AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _animation.value),
                            child: child,
                          );
                        },
                        child: Icon(
                          Icons.download,
                          color: primary,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
                    side: BorderSide(
                      color: secondary,
                      width: 2,
                    ),
                    foregroundColor: primary,
                    backgroundColor: Colors.transparent,
                    overlayColor: primary,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
