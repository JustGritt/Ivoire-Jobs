// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';

import '../../../core/core.dart';
import '../views/views.dart';

class EditEnqueryController extends StatelessController {
  const EditEnqueryController({super.key});

  @override
  Display view(BuildContext context) {
    return Display(
        title: 'Add New Enquery', mobile: const EditEnqueryForMobile());
  }
}
