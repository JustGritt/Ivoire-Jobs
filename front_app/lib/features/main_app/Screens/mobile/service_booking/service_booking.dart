import 'dart:async';

import 'package:barassage_app/core/init_dependencies.dart';
import 'package:barassage_app/features/main_app/Screens/mobile/service_booking/step_date_booking.dart';
import 'package:barassage_app/features/main_app/Screens/mobile/service_booking/step_resume_booking.dart';
import 'package:barassage_app/features/main_app/models/service_models/booking_service_model/booking_service_create_model.dart';
import 'package:barassage_app/features/main_app/services/booking_service_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../models/service_models/booking_service_model/booking_service_created_model.dart';
import '../../../models/service_models/service_created_model.dart';
import 'step_location_booking.dart';

final BookingServiceServices bookingServiceServices =
    serviceLocator<BookingServiceServices>();

class ServiceBookingScreen extends StatefulWidget {
  final ServiceCreatedModel service;
  const ServiceBookingScreen({super.key, required this.service});

  @override
  State<ServiceBookingScreen> createState() => _ServiceBookingScreenState();
}

class _ServiceBookingScreenState extends State<ServiceBookingScreen> {
  int _currentPage = 0;
  Map<String, dynamic> form = {'location': null, 'dateTime': DateTime.now()};
  PageController _pageViewController = PageController();

  @override
  void dispose() {
    _pageViewController.dispose();

    super.dispose();
  }

  Completer<BookingServiceCreatedModel> _completer =
      Completer<BookingServiceCreatedModel>();

  void _createBooking(BookingServiceCreateModel bookingServiceCreateModel) {
    _completer = Completer<BookingServiceCreatedModel>();
    bookingServiceServices.create(bookingServiceCreateModel).then((booking) {
      _completer.complete(booking);
    }).catchError((error) {
      _completer.completeError(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    goNextOrBack(int page) {
      _pageViewController.animateToPage(page,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutQuad);
    }

    AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          leading: IconButton(
              icon: Icon(CupertinoIcons.back, color: theme.primaryColorDark),
              onPressed: () {
                if (_currentPage > 0) {
                  goNextOrBack(_currentPage - 1);
                } else {
                  context.pop();
                }
              }),
        ),
        body: Container(
          height: double.infinity,
          child: Column(
            children: [
              Flexible(
                  child: PageView(
                physics: NeverScrollableScrollPhysics(),
                controller: _pageViewController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: <Widget>[
                  StepLocationBooking(
                    location: form['location'],
                    onEnd: (data) => {
                      setState(() {
                        form['location'] = data;
                      }),
                    },
                  ),
                  StepDateTimeBooking(
                      dateTime: form['dateTime'],
                      onEnd: (dateTime) => {
                            setState(() {
                              form['dateTime'] = dateTime;
                            }),
                          }),
                  (form['location'] != null && form['dateTime'] != null)
                      ? StepResumeBooking(
                          location: form['location'],
                          dateTime: form['dateTime'],
                          onEndAddPhone: (phone) => {
                            print(phone),
                            setState(() {
                              form['phoneNumber'] = phone;
                            }),
                          },
                          service: widget.service,
                        )
                      : Container(),
                ],
              )),
              FutureBuilder<BookingServiceCreatedModel>(
                  future: _completer.future,
                  builder: (context, snapshot) {
                    return bottomHandlerPage(context,
                        disabled: isButtonDisabled(form, _currentPage),
                        text: _currentPage == 2
                            ? appLocalizations.book
                            : appLocalizations.next,
                        onPressed: () => {
                              if (_currentPage < 2)
                                {goNextOrBack(_currentPage + 1)}
                              else
                                {
                                  _createBooking(BookingServiceCreateModel(
                                    location: form['location'],
                                    startTime: form['dateTime'],
                                    phoneNumber: form['phoneNumber'],
                                    serviceId: widget.service.id,
                                  ))
                                }
                            });
                  })
            ],
          ),
        ));
  }
}

Widget bottomHandlerPage(
  BuildContext context, {
  bool disabled = true,
  required Function() onPressed,
  String? text,
}) {
  ThemeData theme = Theme.of(context);
  return Container(
    clipBehavior: Clip.antiAlias,
    padding: const EdgeInsets.only(top: 15, bottom: 20),
    decoration: BoxDecoration(
      color: theme.scaffoldBackgroundColor,
      border: Border(
        top: BorderSide(
          //                    <--- top side
          color: theme.colorScheme.surface,
        ),
      ),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16.0),
        topRight: Radius.circular(16.0),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.grey[200]!,
          offset: Offset(0, -2),
          blurRadius: 30,
          spreadRadius: 2,
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: CupertinoButton(
          disabledColor: theme.colorScheme.surface.withOpacity(0.5),
          color: theme.primaryColor,
          onPressed: disabled ? null : onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text ?? 'Next',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )),
    ),
  );
}

bool isButtonDisabled(Map<String, dynamic> form, int currentStep) {
  switch (currentStep) {
    case 0:
      return form['location'] == null;
    case 1:
      return form['dateTime'] == null;
    case 2:
      return form['phoneNumber'] == null;
    default:
      return false;
  }
}
