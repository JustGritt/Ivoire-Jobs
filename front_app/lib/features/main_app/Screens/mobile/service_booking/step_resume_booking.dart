import 'package:barassage_app/core/helpers/utils_helper.dart';
import 'package:barassage_app/features/main_app/models/location_service.dart';
import 'package:barassage_app/features/main_app/models/service_models/service_created_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:jiffy/jiffy.dart';

class StepResumeBooking extends StatefulWidget {
  final ServiceCreatedModel service;
  final LocationService location;
  final DateTime dateTime;
  final Function(String phone) onEndAddPhone;

  const StepResumeBooking(
      {super.key,
      required this.service,
      required this.location,
      required this.dateTime,
      required this.onEndAddPhone
      });

  @override
  State<StepResumeBooking> createState() => _StepResumeBookingState();
}

class _StepResumeBookingState extends State<StepResumeBooking> {
  @override
  void initState() {
    super.initState();
  }

  final TextEditingController controller = TextEditingController();
  String initialCountry = 'CI';
  PhoneNumber number = PhoneNumber(isoCode: 'CI');

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    String dateTimeFormatted = Jiffy.parse(
            '${widget.dateTime.year}/${widget.dateTime.month}/${widget.dateTime.day}')
        .yMMMMd;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 20),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(children: [
                  ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: Image.network(widget.service.images.first,
                          width: 100, height: 100)),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: Text('Tout est bon ?, réservez votre service !',
                        style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            fontSize: 20,
                            height: 1.2)),
                  ),
                ]),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.location_fill,
                      color: theme.primaryColor,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: Text(widget.location.address,
                          style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                DividerBookingSection(theme),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          CupertinoIcons.cart_fill,
                          color: theme.primaryColor,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(widget.service.category.first,
                            style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: Text('${widget.service.price} XOF',
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(fontSize: 16)),
                    ),
                  ],
                ),
                DividerBookingSection(theme),
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.calendar,
                      color: theme.primaryColor,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: Text(
                          'Votre rendez-vous est prévu pour le ${dateTimeFormatted} à ${widget.dateTime.hour}h ${widget.dateTime.minute}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 6,
            margin: EdgeInsets.symmetric(vertical: 20),
            color: theme.colorScheme.surface.withOpacity(0.3),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Conditions d\'annulation',
                    textAlign: TextAlign.start,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(fontSize: 18, fontWeight: FontWeight.w800)),
                SizedBox(
                  height: 10,
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                          text:
                              'Vous pouvez annuler votre rendez-vous sans frais jusqu\'à',
                          style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: theme.colorScheme.onSurface)),
                      TextSpan(
                        text: ' 24 h ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                          text: 'avant le rendez-vous',
                          style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: theme.colorScheme.onSurface)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 6,
            margin: EdgeInsets.symmetric(vertical: 20),
            color: theme.colorScheme.surface.withOpacity(0.3),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Champ obligatoire*',
                      style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.surface)),
                  SizedBox(
                    height: 6,
                  ),
                  InternationalPhoneNumberInput(
                    onInputChanged: (PhoneNumber number) {
                      if(number.phoneNumber != null) widget.onEndAddPhone(number.phoneNumber!);
                    },
                    autoValidateMode: AutovalidateMode.onUserInteraction,
                    spaceBetweenSelectorAndTextField: 0,
                    inputBorder: OutlineInputBorder(
                      borderSide: BorderSide(style: BorderStyle.none, width: 0),
                      borderRadius: BorderRadius.circular(8),
                    ),

                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      // // Ensure it is only digits and optional '+' or '00' for the country code.
                      // if (!RegExp(r'^(\+|00)?[0-9]+$').hasMatch(value)) {
                      //   return 'Please enter a valid phone number';
                      // }

                      return null; // Return null when the input is valid
                    },
                    countries: ['CI', 'NG'],
                    selectorConfig: SelectorConfig(
                        trailingSpace: false,
                        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                        useBottomSheetSafeArea: true,
                        leadingPadding: 0),
                    hintText: 'Numéro de téléphone',
                    searchBoxDecoration: InputDecoration(
                      hintText: 'Numéro de téléphone',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                    ),
                    selectorTextStyle: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface),
                    initialValue: number,
                    textFieldController: controller,
                    inputDecoration: InputDecoration(
                        hintText: 'Numéro de téléphone',
                        fillColor: theme.colorScheme.surface.withOpacity(0.3),
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(style: BorderStyle.none, width: 0),
                          borderRadius: BorderRadius.circular(8),
                        )),
                    onSaved: (PhoneNumber number) {
                      print('On Saved: $number');
                    },
                  ),
                ],
              )),
          Container(
            height: 6,
            margin: EdgeInsets.symmetric(vertical: 20),
            color: theme.colorScheme.surface.withOpacity(0.3),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text.rich(
              TextSpan(children: [
                TextSpan(
                    text: 'En réservant, vous acceptez nos ',
                    style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: theme.colorScheme.onSurface)),
                TextSpan(
                    text: 'conditions générales d\'utilisation',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        await openUrl('https://barassage.com');
                      }),
              ]),
            ),
          ),
        ]),
      ),
    );
  }
}

Widget DividerBookingSection(ThemeData theme) {
  return Column(
    children: [
      SizedBox(
        height: 10,
      ),
      Divider(
        color: theme.colorScheme.surface,
      ),
      SizedBox(
        height: 10,
      ),
    ],
  );
}
