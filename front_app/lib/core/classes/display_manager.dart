import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Display extends StatelessWidget {
  String title;
  Color? headerColor;

  Widget mobile;
  Widget? desktopLarge, desktop, tabletLandscape, tablet, mobileLandscape;

  Display({
    super.key,
    required this.title,
    required this.mobile,
    this.mobileLandscape,
    this.tablet,
    this.tabletLandscape,
    this.desktop,
    this.desktopLarge,
    this.headerColor,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // log(size.width.toString());
    double width = size.width;
    return Title(
      color: headerColor ?? Theme.of(context).primaryColor,
      title: title,
      child: Container(
        child: (width > 1400 && desktopLarge != null)
            ? desktopLarge
            : (width > 1200 && desktop != null)
                ? desktop
                : (width > 992 && tabletLandscape != null)
                    ? tabletLandscape
                    : (width > 768 && tablet != null)
                        ? tablet
                        : (width > 576 && mobileLandscape != null)
                            ? mobileLandscape
                            : mobile,
      ),
    );
  }
}
