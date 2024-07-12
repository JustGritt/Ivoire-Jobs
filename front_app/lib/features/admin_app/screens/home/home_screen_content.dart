import 'package:barassage_app/features/admin_app/utils/responsive_utils.dart';
import 'package:barassage_app/features/admin_app/screens/home/screens.dart';
import 'package:barassage_app/features/admin_app/utils/home_colors.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class HomeScreenContent extends StatefulWidget {
  static _HomeScreenContentState? of(BuildContext context) => context.findAncestorStateOfType<_HomeScreenContentState>();

  @override
  _HomeScreenContentState createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToTopButton = false;
  double _scrollOffset = 0;

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
    setState(() {
      _scrollOffset = _scrollController.offset;
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.4) {
        _showScrollToTopButton = true;
      } else {
        _showScrollToTopButton = false;
      }
    });
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
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      setState(() {
        _expanded[_currentIndex] = false;
        _currentIndex = (_currentIndex + 1) % _expanded.length;
        _expanded[_currentIndex] = true;
      });
    });
  }

  void _onExpansionChanged(int index, bool expanded) {
    setState(() {
      for (int i = 0; i < _expanded.length; i++) {
        _expanded[i] = i == index && expanded;
      }
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
        CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                minHeight: 80.0,
                maxHeight: 80.0,
                child: Header(
                  scrollToSection: scrollToSection,
                  aboutUsKey: _aboutUsKey,
                  appsKey: _appsKey,
                  faqKey: _faqKey,
                  downloadUrl: dotenv.env['FLUTTER_DOWNLOAD_URL'] ?? '',
                  scrollOffset: _scrollOffset,
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  HeroScreen(aboutUsKey: _aboutUsKey, columns: columns),
                  AdditionalContent(
                    appsKey: _appsKey,
                    downloadUrl: dotenv.env['FLUTTER_DOWNLOAD_URL'] ?? '',
                  ),
                  FAQScreen(
                    faqKey: _faqKey,
                    expanded: _expanded,
                    onExpansionChanged: _onExpansionChanged,
                  ),
                  FooterScreen(),
                ],
              ),
            ),
          ],
        ),
        if (_showScrollToTopButton)
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: _scrollToTop,
              child: const Icon(Icons.arrow_upward, color: tertiary),
              backgroundColor: primary,
            ),
          ),
      ],
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
