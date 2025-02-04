import 'package:barassage_app/features/admin_app/services/admin_service.dart';
import 'package:barassage_app/features/admin_app/widgets/service_card.dart';
import 'package:barassage_app/features/admin_app/widgets/search_input.dart';
import 'package:barassage_app/features/admin_app/utils/home_colors.dart';
import 'package:barassage_app/features/admin_app/models/service.dart';
import 'package:flutter/material.dart';

class ManageServicesScreen extends StatefulWidget {
  const ManageServicesScreen({super.key});

  @override
  State<ManageServicesScreen> createState() => _ManageServicesScreenState();
}

class _ManageServicesScreenState extends State<ManageServicesScreen> {
  late Future<List<Service>> futureServices;
  final TextEditingController _searchController = TextEditingController();
  List<Service> _filteredServices = [];

  @override
  void initState() {
    super.initState();
    futureServices = getServices();
    futureServices.then((services) {
      setState(() {
        _filteredServices = services;
      });
    });
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

  void _handleSearch(String query) {
    futureServices.then((services) {
      final filtered = services.where((service) {
        final serviceName = service.name.toLowerCase();
        final searchQuery = query.toLowerCase();
        return serviceName.contains(searchQuery);
      }).toList();
      setState(() {
        _filteredServices = filtered;
      });
    });
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
            return Column(
              children: [
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Number of services: ${_filteredServices.length}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: primary,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.refresh, color: primary),
                            onPressed: () {
                              futureServices = getServices();
                              futureServices.then((services) {
                                setState(() {
                                  _filteredServices = services;
                                });
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SearchInput(
                        textController: _searchController,
                        hintText: 'Search Services',
                        onChanged: _handleSearch,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ListView.builder(
                      itemCount: _filteredServices.length,
                      itemBuilder: (context, index) {
                        final service = _filteredServices[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: ServiceCard(
                            service: service,
                            onEdit: () => _handleEditService(service),
                          ),
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
