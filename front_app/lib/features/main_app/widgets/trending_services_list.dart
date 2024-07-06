import 'package:barassage_app/features/main_app/app.dart';
import 'package:barassage_app/features/main_app/models/service_models/service_created_model.dart';
import 'package:barassage_app/features/main_app/services/service_services.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/main/trending_services_model.dart';
import 'trending_service.dart';

class TrendingServicesList extends StatefulWidget {
  TrendingServicesList({super.key});

  @override
  State<TrendingServicesList> createState() => _TrendingServicesListState();
}

class _TrendingServicesListState extends State<TrendingServicesList> {
  Future<List<ServiceCreatedModel>> services = Future.value([]);

  @override
  void initState() {
    services = ServiceServices.getAll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300, // Adjust the height as needed to avoid overflow
      child: FutureBuilder(
          future: services,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }
            if (snapshot.data?.isEmpty ?? true) {
              return Center(
                child: Text('No data found'),
              );
            }
            
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      context.push('${App.home}/${App.detailService}');
                    },
                    child: TrendingService(service: snapshot.data![index]),
                  ),
                );
              },
            );
          }),
    );
  }
}
