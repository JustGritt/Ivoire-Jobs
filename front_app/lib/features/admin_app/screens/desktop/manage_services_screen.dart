import 'package:barassage_app/features/admin_app/services/admin_service.dart';
import 'package:flutter/material.dart';

import '../../../main_app/models/main/services_model.dart';

class ManageServicesScreen extends StatefulWidget {
  const ManageServicesScreen({super.key});

  @override
  State<ManageServicesScreen> createState() => _ManageServicesScreenState();
}

class _ManageServicesScreenState extends State<ManageServicesScreen> {
  List<Service> services = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getServices();
  }

  void getServices() async {
    AdminService as = AdminService();
    try {
      var values = await as.getAllServices();
      if (values != null && values is List<Service>) {
        debugPrint('values: $values');
        setState(() {
          services = values.cast<Service>();
          isLoading = false;
        });
      } else {
        debugPrint('Error: Unexpected response type');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error: $e');
      setState(() {
        services = [];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manage Services',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : services.isEmpty
          ? Center(child: Text('No services available'))
          : ListView.builder(
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          return ListTile(
            title: Text(service.title),
            subtitle: Text(service.description),
            trailing: Icon(Icons.edit),
            onTap: () {
              // Handle tap to edit service
            },
          );
        },
      ),
    );
  }
}