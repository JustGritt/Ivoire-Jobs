import 'package:flutter/material.dart';
import 'package:barassage_app/features/admin_app/models/service.dart';
import 'package:intl/intl.dart';

class BanCard extends StatelessWidget {
  final Service service;
  const BanCard({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      color: Colors.grey[200],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Service: ${service.title}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Banned on: ${DateFormat.yMMMd().format(service.createdAt)}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            Text(
              'Description: ${service.description}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              'User ID: ${service.user?.id ?? 'N/A'}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              'Price: ${service.price}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              'Duration: ${service.duration}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              'Status: ${service.status}',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
