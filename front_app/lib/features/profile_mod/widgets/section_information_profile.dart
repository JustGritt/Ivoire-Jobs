import 'package:barassage_app/features/auth_mod/models/user.dart';
import 'package:barassage_app/features/main_app/app.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('General',
                  style: theme.textTheme.displayLarge?.copyWith(fontSize: 20)),
              CupertinoButton(
                  padding: EdgeInsets.all(0),
                  minSize: 0,
                  child: const Text('Edit'),
                  onPressed: () {
                    context.pushNamed(App.editProfile);
                  }),
            ],
          ),
          const SizedBox(height: 25),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Icon(CupertinoIcons.person),
              const SizedBox(width: 20),
              Text('${user.firstName} ${user.lastName}',
                  style: theme.textTheme.labelMedium),
            ],
          ),
          Container(
            color: theme.colorScheme.surface.withOpacity(0.3),
            height: 1,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Icon(CupertinoIcons.mail),
              const SizedBox(width: 20),
              Text(user.email, style: theme.textTheme.labelMedium),
            ],
          ),
          Container(
            color: theme.colorScheme.surface.withOpacity(0.3),
            height: 1,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(CupertinoIcons.text_alignleft),
              const SizedBox(width: 20),
              Flexible(
                child: Wrap(children: [
                  Text(user.bio ?? 'No bio available',
                      style: theme.textTheme.labelMedium)
                ]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
