import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../config/config.dart';
import '../../widgets/trending_services_list.dart';
import '../../widgets/services_entries_list.dart';

class Home extends StatefulWidget {
  final String? title;
  const Home({super.key, this.title});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool dayAndNight = false;

  @override
  void initState() {
    super.initState();
    var tm = context.read<ThemeProvider>();
    dayAndNight = tm.isDarkMode;
  }

  double _currentSliderValue = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Builder(
              builder: (context) => IconButton(
                    icon: const Icon(
                      Icons.menu,
                      color: Colors.black,
                    ),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  )),
        ),
        drawer: const Drawer(),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'You are looking for',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () {
                      },
                      child: const Text(
                        'Filters',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Textfield for search
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: const Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.only(left: 8), // Add this line
                            border: InputBorder.none,
                            hintText: 'Search Service',
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.search),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

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

              // Trending services
              SizedBox(
                height: 200,
                child: ServicesEntriesList(),
              ),
            ],
          ),
        ));
  }
}
