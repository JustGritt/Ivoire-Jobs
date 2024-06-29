import 'package:barassage_app/core/services/firebase_api/firebaseAPI.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_cupertino_navigation_bar/super_cupertino_navigation_bar.dart';

import '../../../../config/config.dart';
import '../../widgets/trending_services_list.dart';
import '../../widgets/services_entries_list.dart';
import './map.dart';

class Home extends StatefulWidget {
  final String? title;
  const Home({super.key, this.title});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool dayAndNight = false;

  @override
  void initState() async {
    await Firebaseapi().initNotifications();
    super.initState();
    // var tm = context.read<ThemeProvider>();
    // dayAndNight = tm.isDarkMode;
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
                  // Search Bar Changes
                },
                onSubmitted: (query) {
                  // On Search Bar submitted
                },
                // Add other search bar properties as needed
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

                  // Trending section
                  const Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Text(
                      'Trending services',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Trending services
                  SizedBox(
                    height: 200,
                    child: TrendingServicesList(),
                  ),

                  const SizedBox(height: 16),

                  // Trending section
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
                              fontWeight: FontWeight.bold),
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
                  ServicesEntriesList(),
                ],
              ),
            ),
          ),
        ));
  }
}
