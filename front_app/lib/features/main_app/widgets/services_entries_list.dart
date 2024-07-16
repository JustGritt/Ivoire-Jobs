import 'package:barassage_app/features/main_app/models/service_models/service_created_model.dart';
import 'package:barassage_app/features/main_app/services/service_services.dart';
import 'package:barassage_app/features/main_app/widgets/service_entry.dart';
import 'package:barassage_app/features/main_app/app.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

class ServicesEntriesList extends StatefulWidget {
  ServicesEntriesList({super.key});

  @override
  State<ServicesEntriesList> createState() => _ServicesEntriesListState();
}

class _ServicesEntriesListState extends State<ServicesEntriesList> {
  Future<List<ServiceCreatedModel>> serviceEntries = Future.value([]);

  @override
  void initState() {
    serviceEntries = ServiceServices.getAll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: serviceEntries,
        builder: (context, state) {
          if (state.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.hasError) {
            return Center(
              child: Text('Error: ${state.error}'),
            );
          } else if (state.data?.isEmpty ?? true) {
            return Center(
              child: Container(
                  margin: EdgeInsets.symmetric(), child: Text('No data found')),
            );
          }

          return Column(
              children: state.data!.map((entry) {
            return GestureDetector(
              onTap: () {
                context.push('${App.home}/${App.detailService}', extra: entry);
              },
              child: ServiceEntry(service: entry),
            );
          }).toList());
        });
  }
}
