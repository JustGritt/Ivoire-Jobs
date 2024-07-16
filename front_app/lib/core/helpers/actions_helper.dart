import 'package:barassage_app/config/config.dart';
import 'package:barassage_app/core/core.dart';
import 'package:flutter/material.dart';

List<Widget> actionsMenu(BuildContext context) {
  return [
    IconButton(
        onPressed: () {
          Nav.to(context, '/profile');
        },
        icon: const Icon(Icons.account_circle_outlined)),
    const DayNightSwitch(),
    // IconButton(
    //   onPressed: () {
    //     doLogout(context);
    //   },
    //   icon: const Icon(Icons.logout),
    // ),
    ActionTopButtons()
  ];
}
