import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../Screens/desktop/about.dart' as desktop;
import '../../Screens/mobile/service.dart' as mobile;
import '../../Screens/tablet/about.dart' as tablet;

class ServicesController extends StatefulController {
  final String _title = 'Services';
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
