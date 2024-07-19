import 'package:barassage_app/features/auth_mod/widgets/app_button.dart' as btn;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:barassage_app/architect.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'dart:io' show Platform;

class WelcomeMailScreen extends StatelessWidget {
  const WelcomeMailScreen({super.key});

  void openMailApp(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    await launch(emailUri.toString());
  }

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
              SizedBox(
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
              // CupertinoButton(
              //     child: Text(appLocalizations.btn_go_to_mail),
              //     onPressed: () async {
              //       if (Platform.isAndroid) {
              //         AndroidIntent intent = AndroidIntent(
              //           action: 'android.intent.action.MAIN',
              //           category: 'android.intent.category.APP_EMAIL',
              //         );
              //         intent.launch().catchError((e) {
              //           print("Error opening email app: $e");
              //         });
              //       } else {
              //         openMailApp('live@admin.com');
              //       }
              //     }),
              btn.AppButton(
                onPressed: () {
                  GoRouter.of(context).go(AuthApp.login);
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
