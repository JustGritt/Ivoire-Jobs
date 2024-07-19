import 'package:barassage_app/core/classes/language_provider.dart';
import 'package:barassage_app/features/auth_mod/models/user.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SectionLanguageProfile extends StatefulWidget {
  final User user;
  const SectionLanguageProfile({super.key, required this.user});

  @override
  _SectionNotificationProfileState createState() =>
      _SectionNotificationProfileState();
}

class _SectionNotificationProfileState extends State<SectionLanguageProfile> {
  @override
  void initState() {
    super.initState();
  }

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
          Text('Language',
              style: theme.textTheme.displayLarge?.copyWith(fontSize: 20)),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Icon(CupertinoIcons.flag),
                  const SizedBox(width: 20),
                  Text(appLocalizations.profile_push_notifications,
                      style: theme.textTheme.labelMedium),
                ],
              ),
              Consumer<LanguageProvider>(builder: (context, provider, child) {
                print(provider.locale);
                return CupertinoButton(
                    color: theme.primaryColor,
                    minSize: 0,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: Text(
                      provider.locale.languageCode,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                    onPressed: () {
                      provider.toggleLocale();
                    });
              })
            ],
          ),
        ],
      ),
    );
  }
}
