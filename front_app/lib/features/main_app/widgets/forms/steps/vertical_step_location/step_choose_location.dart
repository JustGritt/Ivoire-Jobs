import 'package:barassage_app/features/main_app/models/location_service.dart';
import 'package:barassage_app/core/helpers/extentions/string_extension.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:barassage_app/features/main_app/app.dart';
import 'package:pushable_button/pushable_button.dart';
import 'package:barassage_app/config/app_colors.dart';
import 'package:ez_validator/ez_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
              style: const TextStyle(
                color: AppColors.red,
                fontSize: 12,
              )),
          const Spacer(),
          PushableButton(
            height: 40,
            elevation: 4,
            hslColor: HSLColor.fromColor(theme.primaryColor),
            shadow: BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 7,
              offset: const Offset(0, 2),
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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        content: Text("Déplacez la carte pour pouvoir valider la position."),
      ));
      PickResult? pickResult = await context
          .push('${App.services}/${App.placePicker}') as PickResult?;
      if (pickResult != null) {
        LocationService locationService = LocationService(
          latitude: pickResult.geometry!.location.lat,
          longitude: pickResult.geometry!.location.lng,
          postCode: (pickResult.addressComponents != null)
              ? pickResult.addressComponents![2].longName
              : "",
          city: pickResult.vicinity ?? "",
          country: (pickResult.addressComponents != null)
              ? pickResult.addressComponents![3].longName
              : "",
          address: pickResult.formattedAddress ?? "",
        );
        onSelect(locationService);
      }
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
                ? locationService.address.truncateTo(33)
                : "Search for a location",
            style: TextStyle(
              color: locationService != null ? Colors.black : Colors.grey[400],
              fontSize: 16,
            ),
          ),
        ])),
  );
}
