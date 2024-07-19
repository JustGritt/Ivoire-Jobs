import 'package:barassage_app/core/blocs/authentication/authentication_bloc.dart';
import 'package:barassage_app/features/auth_mod/models/user.dart';
import 'package:barassage_app/features/main_app/app.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:barassage_app/core/classes/app_context.dart';
import 'package:barassage_app/core/init_dependencies.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flutter/material.dart';

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
  late AuthenticationBloc _authenticationBloc;

  @override
  void initState() {
    _authenticationBloc = context.read<AuthenticationBloc>()
      ..add(InitiateAuth());
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
          icon: const Icon(Ionicons.briefcase_outline),
          activeColor: theme.primaryColor,
          title: Text(appLocalizations.tab_3),
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

    if (bottomBarItems.length > 3) return;
    _authenticationBloc.stream.listen((state) {
      if (state is AuthenticationSuccessState &&
          state.user.member == UserMemberStatusEnum.member) {
        if (bottomBarItems.length > 3) return;
        setState(() {
          bottomBarItems.insert(
            1,
            FlashyTabBarItem(
              icon: const Icon(Ionicons.star_outline),
              activeColor: theme.primaryColor,
              title: Text(appLocalizations.tab_2),
            ),
          );
        });
      }
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
      '/app/home/serviceBookingSuccess',
      '/app/home/bookingService',
      '/app/home/bookingService',
      '${App.bookingServices}/${App.messages}/${App.messagingChat}'
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
          selectedIndex: getCorespondingIndexSelected(
              widget.navigationShell.currentIndex, state),
          onItemSelected: (int value) {
            int newIndex = getCorrespondingIndex(value, state);
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

int getCorrespondingIndex(int index, AuthenticationState state) {
  switch (index) {
    case 0:
      return 0;
    case 1:
      if (state is AuthenticationSuccessState &&
          state.user.member == UserMemberStatusEnum.member) {
        return 1;
      }
      return 2;
    case 2:
      if (state is AuthenticationSuccessState &&
          state.user.member == UserMemberStatusEnum.member) {
        return 2;
      }
      return 3;
    case 3:
      return 3;
    default:
      return 0;
  }
}

int getCorespondingIndexSelected(int index, AuthenticationState state) {
  switch (index) {
    case 0:
      return 0;
    case 1:
      return 1;
    case 2:
      if (state is AuthenticationSuccessState &&
          state.user.member == UserMemberStatusEnum.member) {
        return 2;
      }
      return 1;
    case 3:
      if (state is AuthenticationSuccessState &&
          state.user.member == UserMemberStatusEnum.member) {
        return 3;
      }
      return 2;
    default:
      return 0;
  }
}
