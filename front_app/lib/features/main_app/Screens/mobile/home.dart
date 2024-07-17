import 'package:barassage_app/features/main_app/widgets/trending_services_list.dart';
import 'package:super_cupertino_navigation_bar/super_cupertino_navigation_bar.dart';
import 'package:barassage_app/features/main_app/widgets/services_entries_list.dart';
import 'package:barassage_app/features/main_app/widgets/filter_chips.dart';
import 'package:barassage_app/core/services/firebase_api/firebaseAPI.dart';
import 'package:barassage_app/features/main_app/Screens/mobile/map.dart';
import 'package:barassage_app/config/config.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:barassage_app/features/main_app/providers/my_services_provider.dart';

class Home extends StatefulWidget {
  final String? title;
  const Home({super.key, this.title});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    Firebaseapi().initNotifications();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MyServicesProvider>(context, listen: false).getAll();
      Provider.of<MyServicesProvider>(context, listen: false).getCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        top: false,
        child: SuperScaffold(
          appBar: SuperAppBar(
            title: const Text(""),
            largeTitle: SuperLargeTitle(
              largeTitle: "Welcome",
            ),
            previousPageTitle: "",
            searchBar: SuperSearchBar(
              onChanged: (query) {
                Provider.of<MyServicesProvider>(context, listen: false).searchService(query);
              },
              onSubmitted: (query) {
                Provider.of<MyServicesProvider>(context, listen: false).searchService(query);
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.location_on),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MapScreen(),
                      ),
                    );
                  },
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
                    Padding(
                      padding: EdgeInsets.only(right: 16.0),
                      child: Text(
                        'View all',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
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
      ),
    );
  }
}
