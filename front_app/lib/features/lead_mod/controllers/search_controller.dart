// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';

import '../../../core/core.dart';
import '../views/views.dart';

class SearchController extends StatelessController {
  const SearchController({super.key});

  @override
  Display view(BuildContext context) {
    return Display(title: 'About', mobile: const SearchForMobile());
  }
}
