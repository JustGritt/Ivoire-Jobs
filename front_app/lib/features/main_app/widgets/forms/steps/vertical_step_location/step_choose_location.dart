import 'package:ez_validator/ez_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pushable_button/pushable_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StepChooseLocation extends StatefulWidget {
  const StepChooseLocation({super.key});

  @override
  State<StepChooseLocation> createState() => _StepChooseLocationState();
}

class _StepChooseLocationState extends State<StepChooseLocation> {
  Map<String, String> form = {};
  Map<dynamic, dynamic> errors = {};

  EzSchema formSchema = EzSchema.shape(
    {
      "location": EzValidator<String>(label: "Location").required(),
    },
  );

  void validate() {
    try {
      final (data, errors_) = formSchema.validateSync(form);
      setState(() {
        errors = errors_;
      });
      if (errors_.entries.every((element) => element.value == null)) {}
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(appLocalizations.service_location,
              style: theme.textTheme.labelLarge),
          const SizedBox(
            height: 12,
          ),
          buttonSearchInput(),
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
    ;
  }
}

Widget buttonSearchInput() {
  return CupertinoButton(
    onPressed: () => {},
    padding: const EdgeInsets.all(0),
    child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[300]!,
              blurRadius: 10,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(children: [
          const Icon(Icons.search),
          const SizedBox(
            width: 12,
          ),
          Text(
            "Search for a location",
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
        ])),
  );
}
