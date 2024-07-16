import 'package:barassage_app/features/lead_mod/lead_app.dart';
import 'package:barassage_app/features/main_app/app.dart';
import 'package:barassage_app/core/core.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ActionTopButtons extends ActionButtons {
  ActionTopButtons({super.key})
      : super(buttonDatas: [
          ButtonData(
            icon: Icons.home,
            label: 'Main App',
            link: App.home,
          ),
          ButtonData(
            icon: Icons.people,
            label: 'Leads App',
            link: LeadApp.home,
          ),
          ButtonData(
            icon: Icons.logout,
            label: 'Logout',
            link: '/logout',
          ),
        ]);
}
