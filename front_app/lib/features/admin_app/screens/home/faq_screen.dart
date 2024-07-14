import 'package:barassage_app/features/admin_app/utils/home_colors.dart';
import 'package:flutter/material.dart';

class FAQScreen extends StatelessWidget {
  final List<bool> expanded;
  final Function(int, bool) onExpansionChanged;
  final GlobalKey faqKey;

  const FAQScreen({
    required this.expanded,
    required this.onExpansionChanged,
    required this.faqKey,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 800;
    final double? containerHeight = isDesktop ? 600 : 500;
    return Container(
      key: faqKey,
      height: containerHeight,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
      color: tertiary,
      child: Center(
        child: FractionallySizedBox(
          widthFactor: isDesktop ? 2 / 3 : 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'FAQ',
                  style: TextStyle(
                      fontSize: 36,
                      color: primary,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 40),
              _buildExpansionTile(
                title: 'How can I reset my password?',
                content:
                    'To reset your password, go to the login page and click on "Forgot Password". You will receive an email with instructions to reset your password.',
                isExpanded: expanded[0],
                onExpansionChanged: (expanded) {
                  onExpansionChanged(0, expanded);
                },
              ),
              _buildExpansionTile(
                title: 'How do I contact customer support?',
                content:
                    'You can contact our customer support team via the "Contact Us" page on our website. We are available 24/7 to assist you with any issues.',
                isExpanded: expanded[1],
                onExpansionChanged: (expanded) {
                  onExpansionChanged(1, expanded);
                },
              ),
              _buildExpansionTile(
                title: 'Where can I find the user manual?',
                content:
                    'The user manual can be found in the "Help" section of our website. It contains detailed information on how to use our application.',
                isExpanded: expanded[2],
                onExpansionChanged: (expanded) {
                  onExpansionChanged(2, expanded);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpansionTile({
    required String title,
    required String content,
    required bool isExpanded,
    required Function(bool) onExpansionChanged,
  }) {
    return ExpansionTile(
      title: Text(
        title,
        style: const TextStyle(color: tertiary),
      ),
      backgroundColor: primary,
      collapsedBackgroundColor: background,
      textColor: Colors.white,
      iconColor: Colors.white,
      collapsedTextColor: Colors.white,
      collapsedIconColor: Colors.white,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            content,
            style: const TextStyle(color: Colors.white70),
          ),
        ),
      ],
      initiallyExpanded: isExpanded,
      onExpansionChanged: (expanded) {
        onExpansionChanged(expanded);
      },
    );
  }
}
