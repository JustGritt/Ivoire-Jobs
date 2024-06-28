import 'package:barassage_app/features/auth_mod/models/user.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class SectionInformationProfile extends StatelessWidget {
  final User user;
  const SectionInformationProfile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    ThemeData theme = Theme.of(context);

    return Container(
      width: width * 0.9,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.surface.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Text('General', style: theme.textTheme.labelMedium),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Ionicons.person),
              Text(user.firstName),
            ],
          ),
        ],
      ),
    );
  }
}
