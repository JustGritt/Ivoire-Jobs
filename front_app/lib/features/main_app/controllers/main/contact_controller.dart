import 'package:barassage_app/core/core.dart';
import 'package:flutter/material.dart';
import 'package:barassage_app/features/main_app/Screens/mobile/contact.dart'
    as mobile;
import 'package:barassage_app/features/main_app/Screens/tablet/contact.dart'
    as tablet;
import 'package:barassage_app/features/main_app/Screens/desktop/contact.dart'
    as desktop;

class ContactController extends StatelessController {
  final String _title = 'Contact Page';
  const ContactController({super.key});

  @override
  bool get auth => false;

  @override
  Display view(BuildContext context) {
    return Display(
      title: _title,
      mobile: mobile.Contact(
        title: _title,
      ),
      tabletLandscape: tablet.Contact(title: _title),
      desktop: desktop.Contact(title: _title),
    );
  }
}
