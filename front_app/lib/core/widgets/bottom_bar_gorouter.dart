import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class BottomBarGoRouter extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const BottomBarGoRouter({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    List<String> hideBottomBarPaths = [
      '/app/services/newService',
      '/app/services/placesPicker',
    ];

    final currentPath = GoRouter.of(context).routeInformationProvider.value.uri;
    // print(currentPath.path);

    
    if (hideBottomBarPaths
        .where((element) => currentPath.path.contains(element))
        .isNotEmpty) {
      return const SizedBox.shrink();
    }

    return FlashyTabBar(
      backgroundColor: theme.scaffoldBackgroundColor,
      selectedIndex: navigationShell.currentIndex,
      showElevation: true,
      onItemSelected: (value) {
        navigationShell.goBranch(value,
            initialLocation: value == navigationShell.currentIndex);
      },
      iconSize: 23.0,
      height: 55.0,
      shadows: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 1.0,
        )
      ],
      items: [
        FlashyTabBarItem(
          icon: const Icon(Ionicons.home_outline),
          activeColor: theme.primaryColor,
          title: Text(appLocalizations.tab_1),
        ),
        FlashyTabBarItem(
          icon: const Icon(Ionicons.star_outline),
          activeColor: theme.primaryColor,
          title: Text(appLocalizations.tab_2),
        ),
        FlashyTabBarItem(
          icon: const Icon(Icons.settings_outlined),
          activeColor: theme.primaryColor,
          title: Text(appLocalizations.tab_3),
        )
      ],
    );
  }
}
