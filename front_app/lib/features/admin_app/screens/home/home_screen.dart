import 'package:barassage_app/features/admin_app/utils/responsive_utils.dart';
import 'package:barassage_app/features/admin_app/utils/home_colors.dart';
import 'package:flutter/material.dart';
import 'home_screen_content.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tertiary,
      endDrawer: isMobile(context) ? _buildDrawer(context) : null,
      body: SafeArea(
        child: HomeScreenContent(),
      ),
    );
  }

  static Widget _buildDrawer(BuildContext context) {
    final contentState = HomeScreenContent.of(context);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.white38,
            ),
            child: Image.asset(
              'assets/images/app-logo.png', // Add your logo here
              height: 40,
            ),
          ),
          _buildDrawerItem(context, 'About Us', contentState?.aboutUsKey),
          _buildDrawerItem(context, 'Apps', contentState?.appsKey),
          _buildDrawerItem(context, 'FAQ', contentState?.faqKey),
          ListTile(
            title:
                const Text('Dashboard', style: TextStyle(color: Colors.white)),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  static ListTile _buildDrawerItem(
      BuildContext context, String title, GlobalKey? key) {
    return ListTile(
      title: Text(title, style: TextStyle(color: Colors.white)),
      onTap: () {
        Navigator.pop(context);
        HomeScreenContent.of(context)?.scrollToSection(key);
      },
    );
  }
}
