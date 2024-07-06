import 'package:barassage_app/features/auth_mod/models/user.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SectionNotificationProfile extends StatelessWidget {
  final User user;
  const SectionNotificationProfile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    ThemeData theme = Theme.of(context);
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Notifications',
              style: theme.textTheme.displayLarge?.copyWith(fontSize: 20)),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Icon(CupertinoIcons.app_badge),
                  const SizedBox(width: 20),
                  Text(appLocalizations.profile_push_notifications,
                      style: theme.textTheme.labelMedium),
                ],
              ),
              CupertinoSwitch(
                  value: true,
                  activeColor: theme.primaryColor,
                  onChanged: (f) {})
            ],
          ),
          Container(
            color: theme.colorScheme.surface.withOpacity(0.3),
            height: 1,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Icon(CupertinoIcons.mail),
                  const SizedBox(width: 20),
                  Text(appLocalizations.profile_messages,
                      style: theme.textTheme.labelMedium),
                ],
              ),
              CupertinoSwitch(
                  value: true,
                  activeColor: theme.primaryColor,
                  onChanged: (f) {})
            ],
          )
        ],
      ),
    );
  }
}
