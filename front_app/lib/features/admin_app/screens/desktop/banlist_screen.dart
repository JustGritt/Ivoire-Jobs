import 'package:barassage_app/features/admin_app/models/service.dart';
import 'package:barassage_app/features/admin_app/widgets/ban_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:barassage_app/features/admin_app/providers/banned_services_provider.dart';
import 'package:intl/intl.dart';


class BanListScreen extends StatefulWidget {
  const BanListScreen({Key? key});

  @override
  _BanListScreenState createState() => _BanListScreenState();
}

class _BanListScreenState extends State<BanListScreen> {
  late Future<List<Service>> futureBannedService;

  @override
  void initState() {
    super.initState();
    final bannedServicesProvier = Provider.of<BannedServicesProvier>(context, listen: false);
    futureBannedService = bannedServicesProvier.getAllBannedServices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Service>>(
        future: futureBannedService,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return const Center(child: Text('There is no banned services yet.'));
          } else if (snapshot.hasData) {
            List<Service> services = snapshot.data!;
            return ListView.builder(
              itemCount: services.length,
              itemBuilder: (context, index) {
                final service = services[index];
                return BanCard(service: service);
              },
            );
          }
          return const Center(child: Text('An error occurred on our end. Please try again later.'));
        },
      ),
    );
  }
}

class ServiceDetailScreen extends StatelessWidget {
  final Service service;

  const ServiceDetailScreen({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8.0),
            Text('Serviceed on ${DateFormat.yMMMd().format(service.createdAt)}'),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BannedServicesProvier()),
      ],
      child: const MaterialApp(
        home: BanListScreen(),
      ),
    ),
  );
}
