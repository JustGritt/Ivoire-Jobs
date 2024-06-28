import 'package:barassage_app/core/blocs/authentication/authentication_bloc.dart';
import 'package:barassage_app/features/profile_mod/widgets/profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';

class ProfilePageScreen extends StatefulWidget {
  const ProfilePageScreen({super.key});

  @override
  State<ProfilePageScreen> createState() => _ProfilePageScreenState();
}

class _ProfilePageScreenState extends State<ProfilePageScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AuthenticationBloc>().add(InitiateAuth());
  }

  @override
  Widget build(BuildContext context) {
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
      body: BlocConsumer<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is AuthenticationSuccessState) {
            print('User: ${state.user.createdAt}');
            
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: ProfileAvatar(user: state.user),
                ),
                const SizedBox(height: 20),
                Text(
                  '${state.user.firstName} ${state.user.lastName}',
                  style: theme.textTheme.displayLarge,
                ),
                const SizedBox(height: 10),
                Text(
                  state.user.createdAt?.toString() ?? '',
                  style: theme.textTheme.displaySmall,
                ),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
