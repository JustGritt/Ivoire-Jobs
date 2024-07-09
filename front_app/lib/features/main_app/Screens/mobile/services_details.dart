import 'package:barassage_app/config/config.dart';
import 'package:barassage_app/features/auth_mod/widgets/app_button.dart';
import 'package:barassage_app/features/main_app/app.dart';
import 'package:barassage_app/features/main_app/models/service_models/service_created_model.dart';
import 'package:barassage_app/features/main_app/widgets/details_service/section_client_detail_service.dart';
import 'package:barassage_app/features/main_app/widgets/details_service/section_top_detail_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:barassage_app/features/main_app/widgets/forms/report_form.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';

class ServiceDetailPage extends StatelessWidget {
  final ServiceCreatedModel service;

  ServiceDetailPage({super.key, required this.service});

  submitReport(String reportReason) {
    // Implement the report submission logic here
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Container(
            height: double.infinity,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16.0),
                    bottomRight: Radius.circular(16.0),
                  ),
                  child: CustomScrollView(
                    physics: ClampingScrollPhysics(),
                    slivers: [
                      SliverAppBar(
                        expandedHeight: 400,
                        pinned: true,
                        leading: IconButton(
                          icon: const Icon(CupertinoIcons.back, size: 30),
                          onPressed: () {
                            context.pop();
                          },
                        ),
                        flexibleSpace: FlexibleSpaceBar(
                          background: Hero(
                            tag: service.id,
                            child: Container(
                              height: 400,
                              child: Stack(
                                children: [
                                  Container(
                                    height: double.infinity,
                                    child: service.images.length > 0
                                        ? Image.network(
                                            service.images.first,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          )
                                        : Container(
                                            color: Colors.grey[300],
                                            width: double.infinity,
                                          ),
                                  ),
                                  Positioned(
                                    bottom: 20,
                                    left: 20,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            CupertinoIcons.star_fill,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            3.5.toString(),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(16.0),
                            topLeft: Radius.circular(16.0),
                          ),
                          child: Container(
                            color: Colors.white,
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                SectionTopDetailService(service: service),
                                SizedBox(height: 16),
                                SectionBarasseurDetailService(service: service),
                                SizedBox(height: 16),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Description',
                                        style: theme.textTheme.labelMedium
                                            ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        service.description,
                                        style: theme.textTheme.labelMedium
                                            ?.copyWith(
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Positioned(
                      //     bottom: 10,
                      //     left: 0,
                      //     right: 0,
                      //     child: Center(
                      //       child: AppButton(
                      //           backgroundColor: theme.primaryColor,
                      //           onPressed: () {},
                      //           textColor: Colors.white,
                      //           label: 'Book Now'),
                      //     ))
                    ],
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    padding: const EdgeInsets.only(top: 15, bottom: 20),
                    decoration: BoxDecoration(
                      color: theme.scaffoldBackgroundColor,
                      border: Border(
                        top: BorderSide(
                          //                    <--- top side
                          color: theme.colorScheme.surface,
                          width: 1.0,
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.surface,
                                ),
                              ),
                              Text(
                                '${service.price.toInt()} XOF',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          CupertinoButton(
                              color: theme.primaryColor,
                              onPressed: () {
                                context.pushNamed(App.bookingService);
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    CupertinoIcons.calendar_today,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Book Now',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )));
  }
}
