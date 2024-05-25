import 'package:clean_architecture/features/main_app/Screens/mobile/services_details.dart';
import 'package:flutter/material.dart';
import '../models/main/trending_services_model.dart';
import 'trending_service.dart';

class TrendingServicesList extends StatelessWidget {
  final TrendingServices trendingServices = TrendingServices();

  TrendingServicesList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300, // Adjust the height as needed to avoid overflow
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: trendingServices.trendingServices.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ServiceDetailPage(
                      service: trendingServices.trendingServices[index],
                    ),
                  ),
                );
              },
              child: TrendingService(service: trendingServices.trendingServices[index]),
            ),
          );
        },
      ),
    );
  }
}
