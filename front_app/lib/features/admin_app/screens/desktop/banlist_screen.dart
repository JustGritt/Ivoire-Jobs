import 'package:barassage_app/features/admin_app/providers/banned_services_provider.dart';
import 'package:barassage_app/features/admin_app/providers/banned_users_provider.dart';
import 'package:barassage_app/features/admin_app/widgets/banned_service_card.dart';
import 'package:barassage_app/features/admin_app/widgets/banned_user_card.dart';
import 'package:barassage_app/features/admin_app/models/banned_user.dart';
import 'package:barassage_app/features/admin_app/models/service.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class BanListScreen extends StatefulWidget {
  const BanListScreen({super.key});

  @override
  _BanListScreenState createState() => _BanListScreenState();
}

class _BanListScreenState extends State<BanListScreen>
  with SingleTickerProviderStateMixin {
  late Future<List<Service>> futureBannedService;
  late Future<List<BannedUser>> futureBannedUsers;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Future.microtask(() {
      final bannedServicesProvider =
          Provider.of<BannedServicesProvider>(context, listen: false);
      futureBannedService = bannedServicesProvider.getAllBannedServices();

      final bannedUsersProvider =
          Provider.of<BannedUsersProvider>(context, listen: false);
      futureBannedUsers = bannedUsersProvider.getAllBannedUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Banned Services'),
              Tab(text: 'Banned Users'),
            ],
            unselectedLabelColor: Colors.grey, // Adjust the color as needed
            indicatorColor: Colors.blue, // Adjust the color as needed
            labelColor: Colors.blue, // Adjust the color as needed
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildBannedServicesView(),
                _buildBannedUsersView(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBannedServicesView() {
    return Consumer<BannedServicesProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (provider.errorMessage.isNotEmpty) {
          return Center(child: Text(provider.errorMessage));
        } else if (provider.services.isEmpty) {
          return const Center(child: Text('No services found.'));
        } else {
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: provider.services.length,
            itemBuilder: (context, index) {
              final service = provider.services[index];
              return BanCard(service: service);
            },
          );
        }
      },
    );
  }

  Widget _buildBannedUsersView() {
    return Consumer<BannedUsersProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (provider.errorMessage.isNotEmpty) {
          return Center(child: Text(provider.errorMessage));
        } else if (provider.users.isEmpty) {
          return const Center(child: Text('No banned users found.'));
        } else {
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: provider.users.length,
            itemBuilder: (context, index) {
              final bannedUser = provider.users[index];
              return BannedUserCard(bannedUser: bannedUser);
            },
          );
        }
      },
    );
  }
}
