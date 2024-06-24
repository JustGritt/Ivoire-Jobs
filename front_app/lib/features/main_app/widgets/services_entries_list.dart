import 'package:barassage_app/features/main_app/Screens/mobile/services_details.dart';
import 'package:flutter/material.dart';
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ServiceDetailPage(
                      // service: e,
                      ),
                ),
              );
            },
            child: ServiceEntry(service: e),
          ),
        );
      }).toList(),
    );
  }
}
