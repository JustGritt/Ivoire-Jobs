import 'package:barassage_app/features/admin_app/services/admin_service.dart';
import 'package:flutter/material.dart';
import 'package:barassage_app/features/admin_app/models/service.dart';

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
      //debugPrint('values: $values');
      setState(() {
        services = values;
        isLoading = false;
      });
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
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 0.66,
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : services.isEmpty
              ? const Center(child: Text('No services available'))
              : ListView.builder(
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];
              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  leading: service.images.isNotEmpty
                      ? Image.network(
                    service.images.first,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  )
                      : const Icon(
                    Icons.image,
                    size: 50,
                  ),
                  title: Text(service.title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(service.description),
                      const SizedBox(height: 5),
                      Text('Price: \$${service.price.toString()}'),
                      Text('Duration: ${service.duration} minutes'),
                    ],
                  ),
                  trailing: const Icon(Icons.edit),
                  onTap: () {
                    // Handle tap to edit service
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
