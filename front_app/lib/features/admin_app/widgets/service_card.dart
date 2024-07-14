import 'package:barassage_app/features/admin_app/models/service.dart';
import 'package:flutter/material.dart';

class ServiceCard extends StatelessWidget {
  final Service service;
  final VoidCallback onEdit;

  const ServiceCard({
    super.key,
    required this.service,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.grey[200],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: service.images.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  service.images.first,
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                ),
              )
            : const Icon(
                Icons.image,
                size: 70,
              ),
        title: Text(
          service.name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(service.description),
            const SizedBox(height: 5),
            Text('Price: \$${service.price.toString()}'),
            Text('Duration: ${service.duration} minutes'),
          ],
        ),
        trailing: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: onEdit,
          ),
        ),
        onTap: onEdit,
      ),
    );
  }
}
