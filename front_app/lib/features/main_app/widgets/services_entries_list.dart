import 'package:clean_architecture/features/main_app/Screens/mobile/services_details.dart';
import 'package:flutter/material.dart';
import '../models/main/services_entry_model.dart';
import 'service_entry.dart';

class ServicesEntriesList extends StatelessWidget {
  final ServiceEntries serviceEntries = ServiceEntries();

  ServicesEntriesList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300, // Adjust the height as needed to avoid overflow
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: serviceEntries.serviceEntries.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 8.0, right: 8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ServiceDetailPage(
                      service: serviceEntries.serviceEntries[index],
                    ),
                  ),
                );
              },
              child: ServiceEntry(service: serviceEntries.serviceEntries[index]),
            ),
          );
        },
      ),
    );
  }
}
