import 'package:barassage_app/core/core.dart';
import 'package:flutter/material.dart';
import 'package:barassage_app/features/main_app/Screens/mobile/news.dart'
    as mobile;
import 'package:barassage_app/features/main_app/Screens/tablet/news.dart'
    as tablet;
import 'package:barassage_app/features/main_app/Screens/desktop/news.dart'
    as desktop;

class NewsController extends StatelessController {
  const NewsController({super.key});

  @override
  bool get auth => true;

  @override
  Display view(BuildContext context) {
    return Display(
      title: 'News Area',
      mobile: const mobile.News(),
      tabletLandscape: const tablet.News(),
      desktop: const desktop.News(),
    );
  }
}
