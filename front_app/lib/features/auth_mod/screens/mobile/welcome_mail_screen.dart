import 'package:barassage_app/architect.dart';
import 'package:barassage_app/config/app_colors.dart';
import 'package:barassage_app/core/helpers/utils_helper.dart';
import 'package:barassage_app/features/auth_mod/auth_mod.dart';
import 'package:barassage_app/features/auth_mod/widgets/app_button.dart' as btn;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';

class WelcomeMailScreen extends StatelessWidget {
  const WelcomeMailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: SvgPicture.asset(
                  fit: BoxFit.fill,
                  'assets/svg/confirmed.svg',
                  width: 180,
                  semanticsLabel: 'Acme Logo',
                ),
              ),
              Text(
                appLocalizations.welcome_title_message,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                width: 250,
                child: Text(
                  textAlign: TextAlign.center,
                  appLocalizations.welcome_description_message,
                  style: const TextStyle(
                    color: AppColors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              CupertinoButton(
                  child: Text(appLocalizations.btn_go_to_mail),
                  onPressed: () {
                    openUrl('mailto:sejpalbhargav67@gmail.com');
                  }),
              btn.AppButton(
                onPressed: () {
                  Navigator.popUntil(
                      context, ModalRoute.withName(AuthApp.login));
                },
                width: 250,
                backgroundColor: theme.primaryColorDark,
                label: appLocalizations.btn_login,
                stretch: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
