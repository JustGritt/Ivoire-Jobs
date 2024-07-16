import 'package:barassage_app/config/app_colors.dart';
import 'package:barassage_app/config/app_config.dart';
import 'package:barassage_app/core/helpers/extentions/string_extension.dart';
import 'package:barassage_app/features/main_app/app.dart';
import 'package:barassage_app/features/main_app/models/service_models/booking_service_model/booking_service_created_model.dart';
import 'package:barassage_app/features/main_app/models/service_models/service_created_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import 'package:jiffy/jiffy.dart';

class ServiceBookingSuccess extends StatelessWidget {
  final ServiceBookingSuccessModel service;
  const ServiceBookingSuccess({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              flex: 6,
              fit: FlexFit.tight,
              child: Column(
                children: [
                  Container(
                    height: 200,
                    child: Center(
                      child: Lottie.asset(
                        'assets/lotties/success_animation.json',
                        height: 150,
                        repeat: false,
                      ),
                    ),
                  ),
                  Text(
                    'Payment successful',
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    width: width * 0.9,
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    decoration: BoxDecoration(
                        color: theme.primaryColor.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${this.service.service.price} ${Config.currency}',
                              style: theme.textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color:
                                    theme.colorScheme.primary.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Payé',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Divider(
                          height: 1,
                          color: theme.colorScheme.surface.withOpacity(.4),
                        ),
                        SizedBox(height: 17),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Booking ID',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: AppColors.grey,
                                )),
                            Text(
                              this
                                  .service
                                  .bookingService
                                  .booking
                                  .bookingId
                                  .toUpperCase(),
                              style: theme.textTheme.labelMedium?.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 17),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Details du service',
                            textAlign: TextAlign.start,
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        RowPaymentBooking(context,
                            value: this.service.service.name.truncateTo(20),
                            label: 'Nom du service'),
                        RowPaymentBooking(context,
                            value: Jiffy.parse(this.service.service.createdAt)
                                .format(pattern: 'dd/MM/yyyy'),
                            label: 'Date'),
                        RowPaymentBooking(context,
                            value: Jiffy.parse(this
                                    .service
                                    .bookingService
                                    .booking
                                    .startTime
                                    .toString())
                                .format(pattern: 'HH:mm'),
                            label: 'Heure'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: Container(
                width: width * 0.9,
                child: CupertinoButton(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  borderRadius: BorderRadius.circular(12),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    context.go(App.bookingServices);
                    // TODO: Ask the tech lead how to pop the current screen
                    // Future.delayed(const Duration(milliseconds: 500), () {
                    //   context.pop();
                    // });
                  },
                  color: theme.primaryColor,
                  child: Text(
                    'Voir mes bookings',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.scaffoldBackgroundColor,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget RowPaymentBooking(BuildContext context,
    {required String value, required String label}) {
  ThemeData theme = Theme.of(context);
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 3),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: AppColors.grey,
            )),
        Text(
          value,
          style: theme.textTheme.labelMedium?.copyWith(
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}

class ServiceBookingSuccessModel {
  final ServiceCreatedModel service;
  final BookingServiceCreatedModel bookingService;
  ServiceBookingSuccessModel(
      {required this.service, required this.bookingService});
}
