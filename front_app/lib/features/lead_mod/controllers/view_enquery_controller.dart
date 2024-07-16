import 'package:barassage_app/features/lead_mod/views/views.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:barassage_app/core/core.dart';
// ignore: implementation_imports

class ViewEnqueryController extends StatelessController {
  const ViewEnqueryController({super.key});

  @override
  Display view(BuildContext context) {
    return Display(title: 'View Lead', mobile: const ViewEnqueryForMobile());
  }
}
