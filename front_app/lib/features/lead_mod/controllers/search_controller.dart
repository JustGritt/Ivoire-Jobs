import 'package:barassage_app/features/lead_mod/views/views.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:barassage_app/core/core.dart';
// ignore: implementation_imports

class SearchController extends StatelessController {
  const SearchController({super.key});

  @override
  Display view(BuildContext context) {
    return Display(title: 'About', mobile: const SearchForMobile());
  }
}
