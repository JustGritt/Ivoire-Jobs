import 'package:barassage_app/config/app_colors.dart';
import 'package:barassage_app/core/helpers/extentions/string_extension.dart';
import 'package:barassage_app/features/main_app/models/location_service.dart';
import 'package:barassage_app/features/main_app/app.dart';
import 'package:ez_validator/ez_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:place_picker/entities/location_result.dart';
import 'package:pushable_button/pushable_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StepChooseLocation extends StatefulWidget {
  final Function(LocationService data) onEnd;
  const StepChooseLocation({super.key, required this.onEnd});

  @override
  State<StepChooseLocation> createState() => _StepChooseLocationState();
}

class _StepChooseLocationState extends State<StepChooseLocation> {
  Map<String, dynamic> form = {};
  Map<dynamic, dynamic> errors = {};

  EzSchema formSchema = EzSchema.shape(
    {
      "location": EzValidator<LocationService>(label: "Location").required(),
    },
  );

  void validate() {
    try {
      final (data, errors_) = formSchema.validateSync(form);
      setState(() {
        errors = errors_;
      });
      if (errors_.entries.every((element) => element.value == null)) {
        widget.onEnd(data['location']);
      }
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
          buttonSearchInput(context, (selected) {
            setState(() {
              form['location'] = selected;
            });
          }, (form['location'] as LocationService?)),
          Text(errors['location'] ?? "",
              style: TextStyle(
                color: AppColors.red,
                fontSize: 12,
              )),
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

Widget buttonSearchInput(
    BuildContext context,
    Function(LocationService locationService) onSelect,
    LocationService? locationService) {
  return CupertinoButton(
    onPressed: () async {
      LocationResult result = await context
          .push('${App.services}/${App.placePicker}') as LocationResult;
      if (result.formattedAddress == null) return;
      LocationService locationService = LocationService(
        latitude: result.latLng!.latitude,
        longitude: result.latLng!.longitude,
        postCode: result.postalCode,
        city: result.city?.name ?? "",
        country: result.country?.name ?? "",
        address: result.formattedAddress!,
      );
      onSelect(locationService);
    },
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
            locationService != null
                ? locationService.address.truncateTo(38)
                : "Search for a location",
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
        ])),
  );
}
