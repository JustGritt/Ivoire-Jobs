import 'package:barassage_app/core/blocs/authentication/authentication_bloc.dart';
import 'package:barassage_app/features/auth_mod/models/user.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      '/app/profile/becomeWorker'
    ];

    final currentPath = navigationShell.shellRouteContext.routerState.uri;

    if (hideBottomBarPaths
        .where((element) => currentPath.path.contains(element))
        .isNotEmpty) {
      return const SizedBox.shrink();
    }

    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        return FlashyTabBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          selectedIndex: navigationShell.currentIndex,
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
            (state is AuthenticationSuccessState &&
                    (state).user.member == UserMemberStatusEnum.member)
                ? FlashyTabBarItem(
                    icon: const Icon(Ionicons.star_outline),
                    activeColor: theme.primaryColor,
                    title: Text(appLocalizations.tab_2),
                  )
                : FlashyTabBarItem(
                    icon: const Icon(Ionicons.search_circle_outline),
                    activeColor: theme.primaryColor,
                    title: Text('jsdjsdj'),
                  ),
            FlashyTabBarItem(
              icon: const Icon(Ionicons.person_outline),
              activeColor: theme.primaryColor,
              title: Text(appLocalizations.tab_3),
            )
          ],
        );
      },
    );
  }
}
