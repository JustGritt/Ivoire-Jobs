import 'package:barassage_app/config/app_colors.dart';
import 'package:barassage_app/core/classes/app_context.dart';
import 'package:barassage_app/core/helpers/extentions/string_extension.dart';
import 'package:barassage_app/core/init_dependencies.dart';
import 'package:ez_validator/ez_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pushable_button/pushable_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StepTimeService extends StatefulWidget {
  final Function(int timeService) onEnd;
  const StepTimeService({super.key, required this.onEnd});

  @override
  State<StepTimeService> createState() => _StepTimeServiceState();
}

class _StepTimeServiceState extends State<StepTimeService> {
  int? duration;
  List<int> timeServices = [30, 60, 90, 120];
  ThemeData theme = Theme.of(serviceLocator<AppContext>().navigatorContext);
  AppLocalizations appLocalizations =
      AppLocalizations.of(serviceLocator<AppContext>().navigatorContext)!;

  Map<String, int> form = {
    "duration": 0,
  };
  Map<dynamic, dynamic> errors = {};

  EzSchema formSchema = EzSchema.shape(
    {
      "duration": EzValidator<int>(label: "Time of service").required(),
    },
  );

  void validate() {
    try {
      final (data, errors_) = formSchema.validateSync(form);
      setState(() {
        errors = errors_;
      });
      if (errors_.entries.every((element) => element.value == null)) {
        widget.onEnd(duration!);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Choisissez la durée approximative de votre service',
              style: theme.textTheme.labelLarge),
          const SizedBox(
            height: 12,
          ),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: timeServices
                .map((e) => squareTimeService(
                  context,
                  selected: duration == e, 
                  onPress: () {
                    form['duration'] = e;
                      setState(() {
                        duration = e;
                      });
                  }, 
                  text: e.toString().durationToTime
                  ))
                .toList(),
          ),
          Text(
            errors['duration'] ?? '',
            style: theme.textTheme.labelLarge!
                .copyWith(color: AppColors.red, fontSize: 12),
          ),
          const Spacer(),
          PushableButton(
            height: 40,
            elevation: 3,
            hslColor: HSLColor.fromColor(theme.primaryColor),
            shadow: BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 7,
              offset: Offset(0, 2),
            ),
            onPressed: validate,
            child: Text(appLocalizations.next,
                style: theme.textTheme.titleMedium!
                    .copyWith(color: theme.scaffoldBackgroundColor)),
          ),
        ],
      ),
    );
  }
}

Widget squareTimeService(BuildContext context,
    {required void Function() onPress,
    required String text,
    bool selected = false}) {
  ThemeData theme = Theme.of(serviceLocator<AppContext>().navigatorContext);
  return CupertinoButton(
    onPressed: onPress,
    minSize: 0,
    padding: const EdgeInsets.all(0),
    child: Container(
      padding: const EdgeInsets.all(5),
      constraints: const BoxConstraints(maxWidth: 100, minHeight: 50),
      decoration: BoxDecoration(
        color: selected ? theme.primaryColor : theme.cardColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey.withOpacity(0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 3,
          ),
        ],
      ),
      child: Center(
          child: Text(text,
              style: theme.textTheme.displayMedium!.copyWith(
                  fontSize: 16, color: theme.scaffoldBackgroundColor))),
    ),
  );
}
