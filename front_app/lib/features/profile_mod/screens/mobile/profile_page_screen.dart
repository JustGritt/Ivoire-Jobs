import 'package:barassage_app/config/app_colors.dart';
import 'package:barassage_app/core/blocs/authentication/authentication_bloc.dart';
import 'package:barassage_app/core/classes/language_provider.dart';
import 'package:barassage_app/features/profile_mod/widgets/avatar_profile.dart';
import 'package:barassage_app/features/profile_mod/widgets/section_information_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class ProfilePageScreen extends StatefulWidget {
  const ProfilePageScreen({super.key});

  @override
  State<ProfilePageScreen> createState() => _ProfilePageScreenState();
}

class _ProfilePageScreenState extends State<ProfilePageScreen> {
  final format = DateFormat('d/MM/yyy');

  @override
  void initState() {
    super.initState();
    context.read<AuthenticationBloc>().add(InitiateAuth());
  }

  @override
  Widget build(BuildContext context) {
    LanguageProvider languageProvider = Provider.of<LanguageProvider>(context);
    ThemeData theme = Theme.of(context);
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
                  CupertinoButton(
                      child: const Text('Logout'),
                      onPressed: () {
                        context.read<AuthenticationBloc>().add(SignOut());
                      }),
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
