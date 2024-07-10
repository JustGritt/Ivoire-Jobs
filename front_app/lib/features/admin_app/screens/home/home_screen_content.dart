import 'dart:async';
import 'package:flutter/material.dart';
import 'package:barassage_app/features/admin_app/utils/responsive_utils.dart';
import 'package:barassage_app/features/admin_app/screens/home/screens.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HomeScreenContent extends StatefulWidget {
  static _HomeScreenContentState? of(BuildContext context) =>
      context.findAncestorStateOfType<_HomeScreenContentState>();

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
  final GlobalKey _faqKey = GlobalKey();

  List<bool> _expanded = [true, false, false];
  int _currentIndex = 0;
  Timer? _timer;

  GlobalKey get aboutUsKey => _aboutUsKey;
  GlobalKey get appsKey => _appsKey;
  GlobalKey get helpKey => _helpKey;
  GlobalKey get roadmapKey => _roadmapKey;
  GlobalKey get faqKey => _faqKey;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _startAutoPlay();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.4) {
      setState(() {
        _showScrollToTopButton = true;
      });
    } else {
      setState(() {
        _showScrollToTopButton = false;
      });
    }
  }

  void scrollToSection(GlobalKey? key) {
    final context = key?.currentContext;
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

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      setState(() {
        _expanded[_currentIndex] = false;
        _currentIndex = (_currentIndex + 1) % _expanded.length;
        _expanded[_currentIndex] = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;

    if (isDesktop(context)) {
      return _buildContent(context, 3);
    } else if (isTablet(context)) {
      return _buildContent(context, 2);
    } else {
      return _buildContent(context, 1);
    }
  }

  Widget _buildContent(BuildContext context, int columns) {
    return Stack(
      children: [
        SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              // Header
              Header(scrollToSection: scrollToSection, aboutUsKey: _aboutUsKey, appsKey: _appsKey,  faqKey: _faqKey, downloadUrl: dotenv.env['DOWNLOAD_URL'] ?? ''),
              // Main Content
              HeroScreen(aboutUsKey: _aboutUsKey, columns: columns),
              // Additional Content
              AdditionalContent(appsKey: _appsKey),
              // FAQ Section
              FAQScreen(
                faqKey: _faqKey,
                expanded: _expanded,
                onExpansionChanged: (index, expanded) {
                  setState(() {
                    _expanded[index] = expanded;
                  });
                },
              ),
              // Footer
              FooterScreen(),
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
}
