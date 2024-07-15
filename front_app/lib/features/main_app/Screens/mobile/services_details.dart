import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:barassage_app/features/main_app/models/service_models/service_created_model.dart';
import 'package:barassage_app/features/main_app/widgets/details_service/section_client_detail_service.dart';
import 'package:barassage_app/features/main_app/widgets/details_service/section_rating_detail_service.dart';
import 'package:barassage_app/features/main_app/widgets/details_service/section_top_detail_service.dart';

import 'package:barassage_app/features/main_app/app.dart';

class ServiceDetailPage extends StatelessWidget {
  final ServiceCreatedModel service;

  ServiceDetailPage({super.key, required this.service});

  submitReport(String reportReason) {
    print('Report submitted: $reportReason');
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
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
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: service.images.isNotEmpty
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
                                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      CupertinoIcons.star_fill,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      '3.5',
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
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SectionTopDetailService(service: service),
                          SizedBox(height: 16),
                          SectionBarasseurDetailService(service: service),
                          SizedBox(height: 16),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Description',
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  service.description,
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16),
                          SectionRatingDetailService(serviceId: service.id),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 15, bottom: 20),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                border: Border(
                  top: BorderSide(
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
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
                          '${service.price} XOF',
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
                      ),
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
