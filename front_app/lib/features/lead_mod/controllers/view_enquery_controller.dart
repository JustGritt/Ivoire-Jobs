// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';

import '../../../core/core.dart';
import '../views/views.dart';

class ViewEnqueryController extends StatelessController {
  const ViewEnqueryController({super.key});

  @override
  Display view(BuildContext context) {
    return Display(title: 'View Lead', mobile: const ViewEnqueryForMobile());
  }
}
