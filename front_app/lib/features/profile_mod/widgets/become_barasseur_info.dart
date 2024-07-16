import 'package:barassage_app/features/profile_mod/services/become_barasseur_services.dart';
import 'package:barassage_app/core/blocs/authentication/authentication_bloc.dart';
import 'package:barassage_app/features/auth_mod/widgets/app_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:barassage_app/core/classes/app_context.dart';
import 'package:barassage_app/core/init_dependencies.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:ez_validator/ez_validator.dart';
import 'package:provider/provider.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
//local

BuildContext rootContext = serviceLocator<AppContext>().navigatorContext;

class BecomeBarasseurInfo extends StatefulWidget {
  const BecomeBarasseurInfo({super.key});

  @override
  State<BecomeBarasseurInfo> createState() => _BecomeBarasseurInfoState();
}

class _BecomeBarasseurInfoState extends State<BecomeBarasseurInfo> {
  Map<String, String?> form = {
    "reason": null,
  };
  Map<dynamic, dynamic> errors = {};

  EzSchema formSchema = EzSchema.shape(
    {
      "reason": EzValidator<String>(label: "Reason").required(),
    },
  );
  BecomeBarasseurService becomeBarasseurService = BecomeBarasseurService();
  Future<void> becomeBarasseurFuture = Future.value();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    void validate() {
      try {
        final (data, errors_) = formSchema.validateSync(form);
        setState(() {
          errors = errors_;
        });
        if (errors_.entries.every((element) => element.value == null)) {
          becomeBarasseurFuture =
              becomeBarasseurService.sendRequest(data['reason']).then((data) {
            context.read<AuthenticationBloc>().add(InitiateAuth());
          });
        }
      } catch (e) {
        print(e);
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GlassmorphicContainer(
          width: 350,
          height: 350,
          borderRadius: 20,
          blur: 30,
          border: 2,
          linearGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.surface.withOpacity(0.5),
                theme.colorScheme.surface.withOpacity(0.5),
              ],
              stops: [
                0.1,
                1,
              ]),
          borderGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.scaffoldBackgroundColor.withOpacity(0.9),
              theme.scaffoldBackgroundColor.withOpacity(0.9),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Icon(
                  Ionicons.star,
                  color: theme.colorScheme.secondaryContainer,
                  size: 14,
                ),
                SvgPicture.asset(
                  fit: BoxFit.fill,
                  'assets/svg/test_gift.svg',
                  width: 50,
                  height: 50,
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        appLocalizations.become_bassage_partner_title
                            .toUpperCase(),
                        style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.scaffoldBackgroundColor,
                            fontWeight: FontWeight.w900,
                            fontSize: 18)),
                  ],
                ),
                SizedBox(height: 10),
                Flexible(
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    onChanged: (value) => form['reason'] = value,
                    maxLines: 10,
                    style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.scaffoldBackgroundColor, fontSize: 15),
                    decoration: InputDecoration(
                      hintText: appLocalizations
                          .become_bassage_partner_input_placeholder,
                      hintStyle: theme.textTheme.labelMedium?.copyWith(
                          color: theme.scaffoldBackgroundColor.withOpacity(.8),
                          fontSize: 15),
                      errorText: errors['reason'],
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: theme.scaffoldBackgroundColor),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: theme.scaffoldBackgroundColor),
                      ),
                      labelStyle: theme.textTheme.labelMedium?.copyWith(
                          color: theme.scaffoldBackgroundColor, fontSize: 18),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox(height: 20),
        FutureBuilder(
            future: becomeBarasseurFuture,
            builder: (context, snapshot) {
              return AppButton(
                isLoading: snapshot.connectionState == ConnectionState.waiting,
                onPressed: validate,
                backgroundColor: theme.primaryColor,
                label: appLocalizations.become_bassage_partner_submit,
              );
            }),
      ],
    );
  }
}
