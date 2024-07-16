import 'package:barassage_app/features/lead_mod/lead_mod.dart';
import 'package:barassage_app/core/widgets/bottom_bar.dart';
import 'package:barassage_app/core/utils/button_data.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class LeadAppBottomBar extends BottomBar {
  LeadAppBottomBar({super.key})
      : super(buttonDatas: [
          ButtonData(
            icon: Icons.dashboard,
            label: 'Dashboard',
            link: LeadApp.home,
          ),
          ButtonData(
            icon: Icons.task_alt,
            label: 'Followup',
            link: LeadApp.followup,
          ),
          ButtonData(
            icon: Icons.search_rounded,
            label: 'Search',
            link: LeadApp.search,
          ),
        ]);
}
