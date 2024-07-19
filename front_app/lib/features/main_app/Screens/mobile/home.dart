import 'package:barassage_app/config/app_ws.dart';
import 'package:barassage_app/core/blocs/authentication/authentication_bloc.dart';
import 'package:barassage_app/features/auth_mod/models/user.dart';
import 'package:barassage_app/features/main_app/utils/home_helpers.dart';
import 'package:barassage_app/features/main_app/widgets/trending_services_list.dart';
import 'package:barassage_app/features/main_app/providers/my_services_provider.dart';
import 'package:barassage_app/features/main_app/widgets/services_entries_list.dart';
import 'package:barassage_app/features/main_app/widgets/home_searchbar.dart';
import 'package:barassage_app/features/main_app/widgets/filter_chips.dart';
import 'package:barassage_app/core/services/firebase_api/firebaseAPI.dart';
import 'package:barassage_app/features/main_app/Screens/mobile/map.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final String? title;
  const Home({super.key, this.title});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    Firebaseapi().initNotifications();
    // HomeHelpers homeHelpers = HomeHelpers();
    // homeHelpers.listenToMaintenanceMode(context);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final myServicesProvider =
          Provider.of<MyServicesProvider>(context, listen: false);
      myServicesProvider.getAll();
      myServicesProvider.getCategories();
      myServicesProvider.getNearbyServices();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    HomeHelpers homeHelpers = HomeHelpers();
    homeHelpers.dispose();
    super.dispose();
  }

  void _performSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MapScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 32.0),
              HomeSearchBar(
                searchController: _searchController,
                onSearch: _performSearch,
              ),
              const FilterChips(),
              const Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Text(
                  'Trending services',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Consumer<MyServicesProvider>(
                builder: (context, myServicesProvider, child) {
                  return SizedBox(
                    height: 200,
                    child: TrendingServicesList(
                      services: myServicesProvider.services,
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Text(
                      'Services near you',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Consumer<MyServicesProvider>(
                builder: (context, myServicesProvider, child) {
                  if (myServicesProvider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (myServicesProvider.hasNoServices) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text('No services available for this filter.'),
                    );
                  }
                  return ServicesEntriesList(
                    services: myServicesProvider.services,
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
