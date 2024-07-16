import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:barassage_app/features/auth_mod/models/user.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileAvatar extends StatefulWidget {
  final User user;
  const ProfileAvatar({super.key, required this.user});

  @override
  State<ProfileAvatar> createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return AdvancedAvatar(
      name: widget.user.firstName,
      style: theme.textTheme.displayLarge?.copyWith(
        color: theme.primaryColor,
      ),
      size: 100,
      decoration: BoxDecoration(
        color: theme.primaryColor.withOpacity(0.5),
        shape: BoxShape.circle,
      ),
      children: [
        Positioned(
          bottom: 0,
          right: 0,
          child: CupertinoButton(
            onPressed: () {},
            padding: const EdgeInsets.all(0),
            minSize: 0,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: theme.primaryColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Ionicons.camera,
                color: theme.scaffoldBackgroundColor,
                size: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
