import 'package:barassage_app/config/app_cache.dart';
import 'package:barassage_app/config/app_colors.dart';
import 'package:barassage_app/core/init_dependencies.dart';
import 'package:barassage_app/features/auth_mod/auth_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

AppCache appCache = serviceLocator<AppCache>();

class OnboardingMobileScreen extends StatefulWidget {
  const OnboardingMobileScreen({super.key});

  @override
  State<OnboardingMobileScreen> createState() => _OnboardingMobileScreenState();
}

class _OnboardingMobileScreenState extends State<OnboardingMobileScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: OnBoardingSlider(
        headerBackgroundColor: theme.primaryColor,
        skipIcon: Icon(CupertinoIcons.arrow_right, color: theme.primaryColor),
        finishButtonText: 'Commencer',
        finishButtonTextStyle: theme.textTheme.labelMedium?.copyWith(
                color: theme.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 16) ??
            TextStyle(),
        onFinish: () async {
          await appCache.setSeenOnboarding();
          context.go(AuthApp.register);
        },
        finishButtonStyle: FinishButtonStyle(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: AppColors.primaryBlueFair,
        ),
        skipTextButton: Text('Passer',
            style:
                theme.textTheme.labelMedium?.copyWith(color: AppColors.white)),
        trailing: Text('Login'),
        pageBackgroundColor: theme.primaryColor,
        background: [
          Container(
              height: 500,
              child: SvgPicture.asset(
                'assets/svg/user_flow-pana.svg',
                height: width,
              )),
          SvgPicture.asset(
            'assets/svg/city_driver_pana.svg',
            width: width,
            height: width,
          ),
          SvgPicture.asset(
            'assets/svg/mobile_payments_rafiki.svg',
            width: width,
            height: width,
          ),
        ],
        totalPage: 3,
        speed: 1.8,
        indicatorAbove: true,
        pageBodies: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: width + 50,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Ne vous épuisez plus à faire milles chose à la fois.',
                      style: theme.textTheme.titleLarge?.copyWith(
                          color: AppColors.white, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: width * 0.7,
                      child: Text(
                          "Reposez-vous et laissez nous vous aider à gérer vos tâches. (Jardinage, ménage, courses, etc.)",
                          textAlign: TextAlign.center,
                          style: theme.textTheme.labelMedium?.copyWith(
                              color: AppColors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w300)),
                    )
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(children: [
              SizedBox(
                height: width + 50,
              ),
              Text(
                'Rien d\'aussi simple.',
                style: theme.textTheme.titleLarge?.copyWith(
                    color: AppColors.white, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: width * 0.7,
                child: Text(
                    "Trouvez un barrasseur près de chez vous en moins de temps pour le dire.",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.labelMedium?.copyWith(
                        color: AppColors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w300)),
              )
            ]),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(children: [
              SizedBox(
                height: width,
              ),
              Text(
                'Réservez de manière entièrement sécurisé.',
                style: theme.textTheme.titleLarge?.copyWith(
                    color: AppColors.white, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: width * 0.7,
                child: Text(
                    "Vous pouvez payer en ligne via (Orange Money, Mtn Money, Wave et Carte Bleue).",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.labelMedium?.copyWith(
                        color: AppColors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w300)),
              )
            ]),
          ),
        ],
      ),
    );
  }
}
