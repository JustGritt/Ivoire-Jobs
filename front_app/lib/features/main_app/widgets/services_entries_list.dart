import 'package:barassage_app/features/main_app/app.dart';
import 'package:barassage_app/features/main_app/models/service_models/service_created_model.dart';
import 'package:barassage_app/features/main_app/widgets/service_entry.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ServicesEntriesList extends StatelessWidget {
  final List<ServiceCreatedModel> services;

  const ServicesEntriesList({super.key, required this.services});

  @override
  Widget build(BuildContext context) {
    if (services.isEmpty) {
      return const Center(
        child: Text('No data found'),
      );
    }

    return Column(
      children: services.map((service) {
        return GestureDetector(
          onTap: () {
            context.push('${App.home}/${App.detailService}', extra: service);
          },
          child: ServiceEntry(service: service),
        );
      }).toList(),
    );
  }
}
