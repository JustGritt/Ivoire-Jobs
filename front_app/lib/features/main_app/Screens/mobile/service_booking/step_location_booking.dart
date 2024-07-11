import 'package:barassage_app/features/main_app/models/location_service.dart';
import 'package:barassage_app/features/main_app/widgets/forms/steps/vertical_step_location/step_choose_location.dart';
import 'package:flutter/material.dart';
import 'package:zod_validation/zod_validation.dart';

class StepLocationBooking extends StatefulWidget {
  final LocationService? location;
  final Function(LocationService data) onEnd;
  const StepLocationBooking({super.key, this.location, required this.onEnd});

  @override
  State<StepLocationBooking> createState() => _StepLocationBookingState();
}

class _StepLocationBookingState extends State<StepLocationBooking> {
  Map<dynamic, dynamic> errors = {};

  Map<String, LocationService?> form = {
    'location': null,
  };

  @override
  void initState() {
    if (widget.location != null) {
      form['location'] = widget.location;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void validate() {
      try {
        final zod = Zod.validate(
            data: form,
            params: {'location': Zod().type<LocationService>().required()});
        print(zod.result);
        if (zod.isNotValid) {
          setState(() {
            errors = zod.result;
          });
        } else {
          if (form['location'] != null) {
            widget.onEnd(form['location']!);
          }
        }
      } catch (e) {
        print(e);
      }
    }

    ThemeData theme = Theme.of(context);
    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ou ce déroulera votre prestation ?',
              style: theme.textTheme.displaySmall?.copyWith(fontSize: 25),
            ),
            const SizedBox(height: 20),
            Text(
              'Choisissez un lieu de rendez-vous',
              style: theme.textTheme.displaySmall
                  ?.copyWith(fontSize: 20, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            buttonSearchInput(context, (selected) {
              setState(() {
                form['location'] = selected;
              });
              validate();
            }, form['location']),
            const SizedBox(height: 10),
            Text(errors['location'] ?? '',
                style: theme.textTheme.displaySmall?.copyWith(
                  fontSize: 16,
                  color: Colors.red,
                )),
          ],
        ),
      ),
    ]);
  }
}
