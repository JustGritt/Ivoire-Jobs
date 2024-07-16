import 'package:barassage_app/core/core.dart';
import 'package:flutter/material.dart';
import 'package:barassage_app/features/main_app/Screens/mobile/about.dart'
    as mobile;
import 'package:barassage_app/features/main_app/Screens/tablet/about.dart'
    as tablet;
import 'package:barassage_app/features/main_app/Screens/desktop/about.dart'
    as desktop;

class AboutController extends StatefulController {
  final String _title = 'About Page';
  const AboutController({super.key});

  @override
  State<AboutController> createState() => _AboutControllerState();
}

class _AboutControllerState extends ControllerState<AboutController> {
  @override
  bool get auth => true;

  @override
  Display view(BuildContext context) {
    return Display(
      title: widget._title,
      mobile: mobile.About(
        title: widget._title,
      ),
      tabletLandscape: tablet.About(title: widget._title),
      desktop: desktop.About(title: widget._title),
    );
  }
}
