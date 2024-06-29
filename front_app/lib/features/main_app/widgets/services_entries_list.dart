import 'package:barassage_app/features/main_app/app.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/main/services_entry_model.dart';
import 'service_entry.dart';

class ServicesEntriesList extends StatelessWidget {
  final ServiceEntries serviceEntries = ServiceEntries();

  ServicesEntriesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: serviceEntries.serviceEntries.map((e) {
        return Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 8.0, right: 8.0),
          child: GestureDetector(
            onTap: () {
              context.push(App.detailService);
            },
            child: ServiceEntry(service: e),
          ),
        );
      }).toList(),
    );
  }
}
