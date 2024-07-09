import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      body: HomeScreenContent(),
    );
  }
}

class HomeScreenContent extends StatefulWidget {
  @override
  _HomeScreenContentState createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToTopButton = false;

  final GlobalKey _aboutUsKey = GlobalKey();
  final GlobalKey _appsKey = GlobalKey();
  final GlobalKey _helpKey = GlobalKey();
  final GlobalKey _roadmapKey = GlobalKey();
  final GlobalKey _ourStoryKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      setState(() {
        _showScrollToTopButton = true;
      });
    } else {
      setState(() {
        _showScrollToTopButton = false;
      });
    }
  }

  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(context,
          duration: const Duration(seconds: 1), curve: Curves.easeInOut);
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                color: Colors.black45,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'assets/images/flutter_viz_logo.png', // Add your logo here
                      height: 40,
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () => _scrollToSection(_aboutUsKey),
                          child: const Text('About Us',
                              style: TextStyle(color: Colors.white)),
                        ),
                        TextButton(
                          onPressed: () => _scrollToSection(_appsKey),
                          child: const Text('Apps',
                              style: TextStyle(color: Colors.white)),
                        ),
                        TextButton(
                          onPressed: () => _scrollToSection(_helpKey),
                          child: const Text('Help',
                              style: TextStyle(color: Colors.white)),
                        ),
                        TextButton(
                          onPressed: () => _scrollToSection(_roadmapKey),
                          child: const Text('Roadmap',
                              style: TextStyle(color: Colors.white)),
                        ),
                        OutlinedButton(
                          onPressed: () {},
                          child: const Text('Dashboard',
                              style: TextStyle(color: Colors.white)),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Main Content
              Container(
                key: _aboutUsKey,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
                child: Column(
                  children: [
                    const Text(
                      'ABOUT US',
                      style: TextStyle(fontSize: 18, color: Colors.blueAccent),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Build Powerful Apps Effortlessly',
                      style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Easily build beautiful apps, connect data, and implement advanced functionality. '
                          'Create your app in just a few hours, with an attractive design and a smooth experience.',
                      style: TextStyle(fontSize: 18, color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatisticCard('235',
                            'Days of hard work to bring Flutterviz to life!'),
                        _buildStatisticCard('100+',
                            'more than 200 demo screen to start your project'),
                        _buildStatisticCard('50+',
                            'Get all the standard Flutter widgets you\'ll need'),
                      ],
                    ),
                    const SizedBox(height: 60),
                    Text(
                      'OUR STORY',
                      key: _ourStoryKey,
                      style: const TextStyle(fontSize: 18, color: Colors.blueAccent),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'We\'re just getting started',
                      style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'We already help over 4000+ companies achieve remarkable results.',
                      style: TextStyle(fontSize: 18, color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Aliqua id fugiat nostrud irure ex duis ea quis id quis ad et. Sunt qui esse pariatur duis deserunt mollit dolore cillum minim tempor enim. Elit aute irure tempor cupidatat incididunt sint deserunt ut voluptate aute id deserunt nisi. Aliqua id fugiat nostrud irure ex duis ea quis id quis ad et. Sunt qui esse pariatur duis deserunt mollit dolore cillum minim tempor enim.',
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                ),
              ),
              // Additional Content (Apps, Help, Roadmap)
              Container(
                key: _appsKey,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
                child: const Text(
                  'Apps Section',
                  style: TextStyle(fontSize: 36, color: Colors.white),
                ),
              ),
              Container(
                key: _helpKey,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
                child: const Text(
                  'Help Section',
                  style: TextStyle(fontSize: 36, color: Colors.white),
                ),
              ),
              Container(
                key: _roadmapKey,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
                child: const Text(
                  'Roadmap Section',
                  style: TextStyle(fontSize: 36, color: Colors.white),
                ),
              ),
              // Footer
              Container(
                color: Colors.black45,
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: const Text('Privacy & Terms',
                              style: TextStyle(color: Colors.white)),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text('Contact Us',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                    const Text('© 2024 FlutterViz Inc.',
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (_showScrollToTopButton)
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: _scrollToTop,
              child: const Icon(Icons.arrow_upward),
              backgroundColor: Colors.blueAccent,
            ),
          ),
      ],
    );
  }

  Widget _buildStatisticCard(String title, String subtitle) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 14, color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
