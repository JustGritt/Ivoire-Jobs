import 'package:barassage_app/config/app_colors.dart';
import 'package:barassage_app/core/blocs/authentication/authentication_bloc.dart';
import 'package:barassage_app/features/auth_mod/models/user.dart';
import 'package:barassage_app/features/bookings_mod/models/booking_appointment.dart';
import 'package:barassage_app/features/bookings_mod/providers/booking_services_provider.dart';
import 'package:barassage_app/features/bookings_mod/widgets/booking_service_card.dart';
import 'package:barassage_app/features/bookings_mod/widgets/sliver_sliding_segmented_delegate.dart';
import 'package:barassage_app/features/main_app/app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class BookingsPageScreen extends StatefulWidget {
  const BookingsPageScreen({super.key});

  @override
  State<BookingsPageScreen> createState() => _BookingsPageScreenState();
}

class _BookingsPageScreenState extends State<BookingsPageScreen> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    final bookingsSevicesProvider =
        Provider.of<BookingServicesProvider>(context, listen: false);
    bookingsSevicesProvider.getAllBookings();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    List<Widget> loadingWidgets = List.generate(
        20,
        (index) => Align(
              key: ValueKey(index),
              child: LoadingAnimationWidget.prograssiveDots(
                color: theme.primaryColor,
                size: 70,
              ),
            ));

    return CupertinoPageScaffold(
      // A ScrollView that creates custom scroll effects using slivers.
      child: Consumer<BookingServicesProvider>(
        builder: (context, bookingProvider, child) => CustomScrollView(
            // A list of sliver widgets.
            slivers: <Widget>[
              CupertinoSliverNavigationBar(
                  brightness: Brightness.light,
                  backgroundColor: AppColors.primaryBlueFair,
                  border: Border(bottom: BorderSide(color: Colors.transparent)),
                  stretch: true,
                  automaticallyImplyLeading: false,
                  largeTitle: Text('Bookings',
                      style: TextStyle(color: theme.primaryColor)),
                  trailing: CupertinoButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      context.pushNamed(App.messages);
                    },
                    padding: EdgeInsets.zero,
                    minSize: 0,
                    child: Container(
                      width: 50,
                      height: 50,
                      child: Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          Icon(
                            CupertinoIcons.chat_bubble_2,
                            color: theme.primaryColor,
                            size: 30,
                          ),
                          Positioned(
                            top: 2,
                            child: Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: AppColors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    bookingProvider
                                            .bookingServiceRequest.data?.length
                                            .toString() ??
                                        '10',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                  )),
              BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, state) {
                  return (state is AuthenticationSuccessState &&
                          state.user.member == UserMemberStatusEnum.member)
                      ? SliverPersistentHeader(
                          delegate: SliverSlidingSegmentedDelegate(
                              Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  color: AppColors.primaryBlueFair,
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CupertinoSlidingSegmentedControl(
                                          groupValue: selectedIndex,
                                          children: {
                                            0: Text('Mes bookings'),
                                            1: Text('Bookings en attente'),
                                          },
                                          onValueChanged: (index) {
                                            if (index is int) {
                                              setState(() {
                                                selectedIndex = index;
                                              });
                                            }
                                          })
                                    ],
                                  )),
                              60),
                          pinned: true,
                        )
                      : SliverToBoxAdapter(
                          child: Container(
                            height: 10,
                          ),
                        );
                },
              ),
              BlocBuilder<AuthenticationBloc, AuthenticationState>(
                  builder: (context, state) {
                List<BookingAppointment> bookings =
                    bookingProvider.bookingServiceRequest.data ?? [];

                if (state is AuthenticationSuccessState &&
                    state.user.member == UserMemberStatusEnum.member) {
                  if (selectedIndex == 0) {
                    bookings = bookings
                        .where((element) => element.userId == state.user.id)
                        .toList();
                  } else {
                    bookings = bookings
                        .where((element) => element.userId != state.user.id)
                        .toList();
                  }
                }

                if (bookingProvider.bookingServiceRequest.isLoading) {
                  return SliverList(
                      delegate: SliverChildListDelegate(loadingWidgets));
                }

                return SliverList(
                    delegate: SliverChildListDelegate(
                  bookings.length == 0
                      ? noBookingsWidget(context)
                      : bookings.map((e) {
                          return BookingServiceCard(
                            appointment: e,
                          );
                        }).toList(),
                ));
              })
            ]),
      ),
    );
  }
}

List<Widget> noBookingsWidget(BuildContext context) {
  ThemeData theme = Theme.of(context);
  double height = MediaQuery.of(context).size.height;
  return [
    Container(
      height: height * 0.5,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.calendar_badge_plus,
              size: 50,
              color: theme.primaryColor,
            ),
            Text(
              'No Bookings',
              style: TextStyle(
                color: theme.primaryColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30),
            CupertinoButton(
              disabledColor: theme.colorScheme.surface.withOpacity(0.5),
              color: theme.primaryColor,
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              onPressed: () {
                HapticFeedback.lightImpact();
                context.go(App.home);
              },
              child: Text(
                'Éffectuer une réservation',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    ),
  ];
}
