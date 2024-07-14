import 'package:barassage_app/architect.dart';
import 'package:barassage_app/features/profile_mod/services/notification_preferences.dart';
import 'package:barassage_app/features/profile_mod/models/notification_preferences.dart';
import 'package:barassage_app/features/auth_mod/models/user.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SectionNotificationProfile extends StatefulWidget {
  final User user;
  const SectionNotificationProfile({super.key, required this.user});

  @override
  _SectionNotificationProfileState createState() =>
      _SectionNotificationProfileState();
}

class _SectionNotificationProfileState
    extends State<SectionNotificationProfile> {
  late NotificationPreferencesService _notificationPreferencesService;
  NotificationPreferences? _preferences;

  @override
  void initState() {
    super.initState();
    _notificationPreferencesService = NotificationPreferencesService();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    try {
      _preferences = await _notificationPreferencesService.fetchPreferences(widget.user.id);
      if (_preferences == null) {
        _preferences = NotificationPreferences(
          bookingNotification: false,
          messageNotification: false,
          pushNotification: false,
          serviceNotification: false,
        );
      }
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _preferences = NotificationPreferences(
            bookingNotification: false,
            messageNotification: false,
            pushNotification: false,
            serviceNotification: false,
          );
        });
      }
    }
  }

  Future<void> _updatePreferences() async {
    if (_preferences != null) {
      try {
        await _notificationPreferencesService.storePreferences(_preferences!);
      } catch (e) {
        debugPrint("Error updating preferences: $e");
      }
    } else {
      debugPrint("Preferences are null, cannot update");
    }
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
                  value: _preferences?.pushNotification ?? false,
                  activeColor: theme.primaryColor,
                  onChanged: (value) {
                    setState(() {
                      _preferences = _preferences?.copyWith(pushNotification: value);
                    });
                    _updatePreferences();
                  })
            ],
          ),
          Container(
            color: theme.colorScheme.surface.withOpacity(0.3),
            height: 1,
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
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
                  value: _preferences?.messageNotification ?? false,
                  activeColor: theme.primaryColor,
                  onChanged: (value) {
                    setState(() {
                      _preferences = _preferences?.copyWith(messageNotification: value);
                    });
                    _updatePreferences();
                  })
            ],
          ),
          Container(
            color: theme.colorScheme.surface.withOpacity(0.3),
            height: 1,
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Icon(CupertinoIcons.calendar),
                  const SizedBox(width: 20),
                  Text(appLocalizations.profile_messages,
                      style: theme.textTheme.labelMedium),
                ],
              ),
              CupertinoSwitch(
                  value: _preferences?.bookingNotification ?? false,
                  activeColor: theme.primaryColor,
                  onChanged: (value) {
                    setState(() {
                      _preferences = _preferences?.copyWith(bookingNotification: value);
                    });
                    _updatePreferences();
                  })
            ],
          ),
          Container(
            color: theme.colorScheme.surface.withOpacity(0.3),
            height: 1,
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Icon(CupertinoIcons.gear),
                  const SizedBox(width: 20),
                  Text(appLocalizations.profile_messages,
                      style: theme.textTheme.labelMedium),
                ],
              ),
              CupertinoSwitch(
                  value: _preferences?.serviceNotification ?? false,
                  activeColor: theme.primaryColor,
                  onChanged: (value) {
                    setState(() {
                      _preferences = _preferences?.copyWith(serviceNotification: value);
                    });
                    _updatePreferences();
                  })
            ],
          ),
        ],
      ),
    );
  }
}
