import 'package:barassage_app/features/lead_mod/views/views.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:barassage_app/core/core.dart';
// ignore: implementation_imports

class AddEnqueryController extends StatelessController {
  const AddEnqueryController({super.key});

  @override
  Display view(BuildContext context) {
    return Display(
        title: 'Add New Enquery', mobile: const AddEnqueryForMobile());
  }
}
