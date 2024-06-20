import 'package:barassage_app/core/classes/app_context.dart';
import 'package:barassage_app/core/init_dependencies.dart';
import 'package:ez_validator/ez_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pushable_button/pushable_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StepTimeService extends StatefulWidget {
  final Function(String timeService) onEnd;
  const StepTimeService({super.key, required this.onEnd});

  @override
  State<StepTimeService> createState() => _StepTimeServiceState();
}

class _StepTimeServiceState extends State<StepTimeService> {
  String? timeService;
  List<String> timeServices = ['2h 30m', '3h', '4h'];
  ThemeData theme = Theme.of(serviceLocator<AppContext>().navigatorContext);
  AppLocalizations appLocalizations =
      AppLocalizations.of(serviceLocator<AppContext>().navigatorContext)!;

  Map<String, String> form = {};
  Map<dynamic, dynamic> errors = {};

  EzSchema formSchema = EzSchema.shape(
    {
      "timeService": EzValidator<String>(label: "Time of service").required(),
    },
  );

  void validate() {
    try {
      final (data, errors_) = formSchema.validateSync(form);
      setState(() {
        errors = errors_;
      });
      if (errors_.entries.every((element) => element.value == null)) {
        widget.onEnd(timeService!);
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
            children: timeServices
                .map((e) => squareTimeService(context,
                        selected: timeService == e, onPress: () {
                           form['timeService'] = e;
                      setState(() {
                        timeService = e;
                      });
                    }, text: e))
                .toList(),
          ),
          Text(
            errors['timeService'] ?? '',
            style: theme.textTheme.labelLarge!
                .copyWith(color: theme.errorColor, fontSize: 12),
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
              style: theme.textTheme.bodyText1!.copyWith(fontSize: 16))),
    ),
  );
}
