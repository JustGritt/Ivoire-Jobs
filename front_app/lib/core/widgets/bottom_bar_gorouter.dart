import 'dart:developer';

import 'package:barassage_app/core/blocs/authentication/authentication_bloc.dart';
import 'package:barassage_app/core/classes/app_context.dart';
import 'package:barassage_app/core/init_dependencies.dart';
import 'package:barassage_app/features/auth_mod/models/user.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flutter/material.dart';

AuthenticationBloc _authenticationBloc = serviceLocator<AuthenticationBloc>();
BuildContext _context = serviceLocator<AppContext>().navigatorContext;

// ignore: must_be_immutable
class BottomBarGoRouter extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  const BottomBarGoRouter({super.key, required this.navigationShell});

  @override
  State<BottomBarGoRouter> createState() => _BottomBarGoRouterState();
}

class _BottomBarGoRouterState extends State<BottomBarGoRouter> {
  List<FlashyTabBarItem> bottomBarItems = [];

  @override
  void initState() {
    ThemeData theme = Theme.of(_context);
    AppLocalizations appLocalizations = AppLocalizations.of(_context)!;
    setState(() {
      bottomBarItems = [
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
          icon: const Icon(Ionicons.person_outline),
          activeColor: theme.primaryColor,
          title: Text(appLocalizations.tab_4),
        )
      ];
    });

    WidgetsBinding.instance
        .addPostFrameCallback((_) => initBottomBarItems(context));
    super.initState();
  }

  void initBottomBarItems(BuildContext context) {
    ThemeData theme = Theme.of(context);
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    _authenticationBloc.add(InitiateAuth());
    if (bottomBarItems.length > 3) return;
    _authenticationBloc.stream.listen((state) {
      if (state is AuthenticationSuccessState &&
          state.user.member == UserMemberStatusEnum.member) {
        setState(() {
          bottomBarItems.insert(
              2,
              FlashyTabBarItem(
                icon: const Icon(Ionicons.briefcase_outline),
                activeColor: theme.primaryColor,
                title: Text(appLocalizations.tab_3),
              ));
        });
      }

      inspect(bottomBarItems.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    List<String> hideBottomBarPaths = [
      '/app/services/newService',
      '/app/services/placesPicker',
      '/app/profile/becomeWorker',
      '/app/home/detailService',
      '/app/home/bookingService',
    ];

    final currentPath =
        widget.navigationShell.shellRouteContext.routerState.uri;

    if (hideBottomBarPaths
        .where((element) => currentPath.path.contains(element))
        .isNotEmpty) {
      return const SizedBox.shrink();
    }

    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        return FlashyTabBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          selectedIndex: widget.navigationShell.currentIndex,
          onItemSelected: (int value) {
            int newIndex = bottomBarItems.indexWhere((element) =>
                element.title.toString() ==
                bottomBarItems[value].title.toString());
            widget.navigationShell.goBranch(newIndex,
                initialLocation: value == widget.navigationShell.currentIndex);
          },
          iconSize: 23.0,
          height: 55.0,
          shadows: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 1.0,
            )
          ],
          items: bottomBarItems,
        );
      },
    );
  }
}
