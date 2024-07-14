import 'package:barassage_app/features/profile_mod/widgets/section_booking_history.dart';
import 'package:barassage_app/features/profile_mod/widgets/section_notification_profile.dart';
import 'package:barassage_app/features/profile_mod/widgets/section_information_profile.dart';
import 'package:barassage_app/features/profile_mod/widgets/section_information_app.dart';
import 'package:barassage_app/core/blocs/authentication/authentication_bloc.dart';
import 'package:barassage_app/features/profile_mod/widgets/avatar_profile.dart';
import 'package:barassage_app/core/classes/language_provider.dart';
import 'package:barassage_app/core/helpers/constants_helper.dart';
import 'package:barassage_app/features/auth_mod/models/user.dart';
import 'package:barassage_app/features/main_app/app.dart';
import 'package:barassage_app/config/app_colors.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProfilePageScreen extends StatefulWidget {
  const ProfilePageScreen({super.key});

  @override
  State<ProfilePageScreen> createState() => _ProfilePageScreenState();
}

class _ProfilePageScreenState extends State<ProfilePageScreen> {
  final format = DateFormat('d/MM/yyy');

  @override
  void initState() {
    context.read<AuthenticationBloc>().add(InitiateAuth());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LanguageProvider languageProvider = Provider.of<LanguageProvider>(context);
    ThemeData theme = Theme.of(context);
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        actions: [
          IconButton(
            icon: Icon(
              Ionicons.ellipsis_horizontal,
              color: theme.primaryColorDark,
            ),
            onPressed: () {
              // Navigator.of(context).pushNamed(App.profile);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: BlocConsumer<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is AuthenticationSuccessState) {
              return Column(
                children: <Widget>[
                  Center(
                    child: ProfileAvatar(user: state.user),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '${state.user.firstName} ${state.user.lastName}',
                    style: theme.textTheme.displayLarge,
                  ),
                  Text(
                      DateFormat.yMMMMd(languageProvider.locale.toString())
                          .format(state.user.createdAt),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: AppColors.grey,
                        fontWeight: FontWeight.w500,
                      )),
                  const SizedBox(height: 20),
                  SectionInformationProfile(user: state.user),
                  const SizedBox(height: 20),
                  SectionNotificationProfile(user: state.user),
                  const SizedBox(height: 20),
                  SectionBookingsHistory(user: state.user),
                  const SizedBox(height: 20),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: getStatusUser(context, state.user)),
                  CupertinoButton(
                      child: const Text('Logout'),
                      onPressed: () {
                        context.read<AuthenticationBloc>().add(SignOut());
                      }),
                  SectionInformationApp()
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}

Widget getStatusUser(BuildContext context, User user) {
  print(user.member);
  ThemeData theme = Theme.of(context);
  AppLocalizations appLocalizations = AppLocalizations.of(context)!;
  double width = MediaQuery.of(context).size.width;

  if (user.member == UserMemberStatusEnum.member) {
    return const Text('Worker');
  } else if (user.member == UserMemberStatusEnum.processing) {
    return Row(
      children: [
        Text('Status: ',
            style:
                theme.textTheme.displayMedium?.copyWith(color: AppColors.grey)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.yellow,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
              child: Text('Pending',
                  style: TextStyle(
                      color: theme.primaryColorDark,
                      fontWeight: FontWeight.bold))),
        ),
      ],
    );
  } else {
    return Container(
        width: width * .9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
              colors: [IVORYCOAST_COLORS[0], IVORYCOAST_COLORS[2]],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(0.5, 0.0),
              stops: [0.0, 1.0]),
        ),
        child: CupertinoButton(
          color: Colors.transparent,
          child: Text(appLocalizations.profile_become_bassage_partner,
              style: theme.textTheme.displayMedium
                  ?.copyWith(color: AppColors.white, fontSize: 17)),
          onPressed: () {
            context.pushNamed(App.becomeWorker);
          },
        ));
  }
}
