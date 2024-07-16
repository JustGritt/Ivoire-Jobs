import 'package:barassage_app/core/core.dart';
import 'package:flutter/material.dart';
import 'package:barassage_app/features/main_app/Screens/tablet/about.dart'
    as tablet;
import 'package:barassage_app/features/main_app/Screens/desktop/about.dart'
    as desktop;
import 'package:barassage_app/features/main_app/Screens/mobile/service.dart'
    as mobile;

class ServicesController extends StatefulController {
  final String _title = 'My services';
  const ServicesController({super.key});

  @override
  State<ServicesController> createState() => _ServicesControllerState();
}

class _ServicesControllerState extends ControllerState<ServicesController> {
  @override
  bool get auth => true;

  @override
  Display view(BuildContext context) {
    return Display(
      title: widget._title,
      mobile: mobile.Service(
        title: widget._title,
      ),
      tabletLandscape: tablet.About(title: widget._title),
      desktop: desktop.About(title: widget._title),
    );
  }
}
