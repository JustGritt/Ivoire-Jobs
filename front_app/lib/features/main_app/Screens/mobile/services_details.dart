import 'package:barassage_app/features/main_app/models/main/services_entry_model.dart';
import 'package:barassage_app/features/main_app/models/main/services_model.dart';
import 'package:flutter/material.dart';
import 'package:barassage_app/features/main_app/widgets/forms/report_form.dart';

class ServiceDetailPage extends StatelessWidget {
  final Service service = ServiceEntries().serviceEntries[0];

  ServiceDetailPage({super.key});

  submitReport(String reportReason) {
    // Implement the report submission logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // Black return button
        leading: Builder(
            builder: (context) => IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                  onPressed: () => Navigator.pop(context),
                )),
        title: Text(
          service.title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Image.network(
            service.image,
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
          ),

          Column(
            children: [
              const SizedBox(height: 24),

              // Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  service.title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  service.description,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Details
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.category),
                        const SizedBox(width: 4),
                        Text(service.category.label),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Row(
                      children: [
                        const Icon(Icons.timer),
                        const SizedBox(width: 4),
                        Text('${service.duration} min'),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Row(
                      children: [
                        const Icon(Icons.star),
                        const SizedBox(width: 4),
                        Text(service.rating.toString()),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Align(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal, // Enable horizontal scrolling
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .center, // This centers the buttons within the Row itself
                  children: [
                    ElevatedButton(
                      onPressed: null,
                      child: const Text('Book Now'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: null,
                      child: const Text('Let\'s Chat'),
                    ),
                    const SizedBox(width: 16),

                    // Report button
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const ReportDialog(); // Use the new ReportDialog widget
                          },
                        );
                      },
                      child: const Text('Report'),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Align to the left
          const Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Text(
                      'Reviews',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '(6)',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
