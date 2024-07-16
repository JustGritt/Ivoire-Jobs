import 'package:barassage_app/features/lead_mod/lead_mod.dart';
import 'package:barassage_app/core/core.dart';
import 'package:flutter/material.dart';

class FollowupForMobile extends StatelessWidget {
  const FollowupForMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Followup'),
        actions: actionsMenu(context),
      ),
      bottomNavigationBar: LeadAppBottomBar(),
    );
  }
}
