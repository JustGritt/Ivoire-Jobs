import 'package:barassage_app/features/admin_app/models/service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BanCard extends StatelessWidget {
  final Service service;
  const BanCard({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[200],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reason: ${service.title} - ${DateFormat.yMMMd().format(service.createdAt)}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text('User ID: ${service.id}'),
            SizedBox(height: 4),
            Text('Service ID: ${service.price}'),
          ],
        ),
      ),
    );
  }
}
