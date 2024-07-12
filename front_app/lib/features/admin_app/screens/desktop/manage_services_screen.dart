import 'package:barassage_app/features/admin_app/services/admin_service.dart';
import 'package:barassage_app/features/admin_app/widgets/service_card.dart';
import 'package:barassage_app/features/admin_app/models/service.dart';
import 'package:flutter/material.dart';

class ManageServicesScreen extends StatefulWidget {
  const ManageServicesScreen({super.key});

  @override
  State<ManageServicesScreen> createState() => _ManageServicesScreenState();
}

class _ManageServicesScreenState extends State<ManageServicesScreen> {
  late Future<List<Service>> futureServices;

  @override
  void initState() {
    super.initState();
    futureServices = getServices();
  }

  Future<List<Service>> getServices() async {
    AdminService as = AdminService();
    try {
      return await as.getAllServices();
    } catch (e) {
      debugPrint('Error: $e');
      return [];
    }
  }

  void _handleEditService(Service service) {
    debugPrint('Edit service: ${service.name}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Service>>(
        future: futureServices,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return const Center(child: Text('No services available.'));
          } else if (snapshot.hasData) {
            List<Service> services = snapshot.data!;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Total Services: ${services.length}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ListView.builder(
                      itemCount: services.length,
                      itemBuilder: (context, index) {
                        final service = services[index];
                        return ServiceCard(
                          service: service,
                          onEdit: () => _handleEditService(service),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          }
          return const Center(child: Text('No services available.'));
        },
      ),
    );
  }
}
