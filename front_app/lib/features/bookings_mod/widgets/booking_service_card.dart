import 'package:barassage_app/features/bookings_mod/models/booking_appointment.dart';
import 'package:barassage_app/config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class BookingServiceCard extends StatefulWidget {
  final BookingAppointment appointment;
  const BookingServiceCard({super.key, required this.appointment});

  @override
  State<BookingServiceCard> createState() => _BookingServiceCardState();
}

class _BookingServiceCardState extends State<BookingServiceCard> {
  final String imageUrl =
      'https://images.unsplash.com/photo-1720728659925-9ca9a38afb2c?q=80&w=2075&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D';

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        print('he');
      },
      child: Container(
        height: 130,
        clipBehavior: Clip.hardEdge,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.withOpacity(0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: theme.primaryColor.withOpacity(0.2),
              spreadRadius: .4,
              blurRadius: 20,
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 110,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                children: [
                  Container(
                    height: double.infinity,
                    width: double.infinity,
                    child: Image.network(
                      widget.appointment.service.images.first.url,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(4),
                    child: Stack(
                      children: [
                        // Icon(
                        //   CupertinoIcons.chat_bubble_2_fill,
                        //   size: 30,
                        //   color: Colors.white,
                        // ),
                        // notification badge
                        Positioned(
                          right: 0,
                          top: -4,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.red,
                            ),
                            child: Text(
                              '2',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 5,
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlueFair,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          widget.appointment.startTime.isBefore(DateTime.now())
                              ? 'Terminé'
                              : 'A venir',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.primaryColor,
                            fontSize: 12,
                          ),
                        )),
                  ),
                ],
              ),
            ),
            Flexible(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(left: 18, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 18,
                              color: Colors.amber,
                            ),
                            Text('4.8',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: theme.primaryColor,
                                )),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 18,
                              color: theme.colorScheme.surface,
                            ),
                            Text('Abidjan'),
                          ],
                        ),
                      ],
                    ),
                    Text(widget.appointment.service.title,
                        style: theme.textTheme.displayMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColorDark,
                            fontSize: 20)),
                    Text('Par. ${widget.appointment.contact.firstName}',
                        style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.surface,
                            fontWeight: FontWeight.w400,
                            fontSize: 14)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text.rich(
                          TextSpan(
                            text: '${widget.appointment.service.price}',
                            style: theme.textTheme.labelMedium?.copyWith(
                                color: theme.primaryColorDark,
                                fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                text: '/heure',
                                style: theme.textTheme.labelMedium?.copyWith(
                                    color: theme.colorScheme.surface,
                                    fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.primaryBlueFair,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                Jiffy.parse(
                                        widget.appointment.startTime.toString())
                                    .yMd,
                                style: theme.textTheme.labelMedium?.copyWith(
                                    color: theme.primaryColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                Jiffy.parse(
                                        widget.appointment.startTime.toString())
                                    .jm,
                                style: theme.textTheme.labelMedium?.copyWith(
                                    color: theme.primaryColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
