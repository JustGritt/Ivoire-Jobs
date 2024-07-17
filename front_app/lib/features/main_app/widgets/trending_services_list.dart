import 'package:barassage_app/features/main_app/models/service_models/service_created_model.dart';
import 'package:barassage_app/features/main_app/widgets/trending_service.dart';
import 'package:flutter/material.dart';

class TrendingServicesList extends StatelessWidget {
  final List<ServiceCreatedModel> services;

  const TrendingServicesList({super.key, required this.services});

  @override
  Widget build(BuildContext context) {
    if (services.isEmpty) {
      return Container(
        margin: const EdgeInsets.only(left: 16),
        child: Text('No services available for this filter.'),
      );
    }

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: services.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return TrendingService(service: services[index]);
      },
    );
  }
}