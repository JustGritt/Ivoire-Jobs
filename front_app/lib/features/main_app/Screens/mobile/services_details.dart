import 'package:barassage_app/features/main_app/models/main/rating_model.dart';
import 'package:barassage_app/features/main_app/widgets/details_service/section_rating_detail_service.dart';
import 'package:barassage_app/features/main_app/widgets/details_service/section_client_detail_service.dart';
import 'package:barassage_app/features/main_app/widgets/details_service/section_top_detail_service.dart';
import 'package:barassage_app/features/main_app/models/service_models/service_created_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:barassage_app/features/main_app/app.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:barassage_app/features/main_app/providers/ratings_provider.dart';

class ServiceDetailPage extends StatefulWidget {
  final ServiceCreatedModel service;

  ServiceDetailPage({super.key, required this.service});

  @override
  _ServiceDetailPageState createState() => _ServiceDetailPageState();
}

class _ServiceDetailPageState extends State<ServiceDetailPage> {
  late Future<List<Rating>> _ratingsFuture;

  @override
  void initState() {
    super.initState();
    _ratingsFuture = _fetchRatings();
  }

  Future<List<Rating>> _fetchRatings() async {
    final ratingsProvider = Provider.of<RatingsProvider>(context, listen: false);
    return await ratingsProvider.getServiceRatings(widget.service.id);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        top: false,
        child: ChangeNotifierProvider(
          create: (_) => RatingsProvider(),
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
                      flexibleSpace: Consumer<RatingsProvider>(
                        builder: (context, ratingsProvider, child) {
                          return FutureBuilder<List<Rating>>(
                            future: _ratingsFuture,
                            builder: (context, snapshot) {
                              double averageRating = 0.0;
                              String ratingDisplay = 'No ratings yet';
                              if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                                if (ratingsProvider.ratings.isNotEmpty) {
                                  averageRating = ratingsProvider.getAverageRating();
                                  ratingDisplay = averageRating.toStringAsFixed(1);
                                }
                              }
                              return FlexibleSpaceBar(
                                background: Hero(
                                  tag: widget.service.id,
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: widget.service.images.isNotEmpty
                                            ? Image.network(
                                                widget.service.images.first,
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
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                CupertinoIcons.star_fill,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                ratingDisplay,
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
                              );
                            },
                          );
                        },
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SectionTopDetailService(service: widget.service),
                            SizedBox(height: 16),
                            SectionBarasseurDetailService(service: widget.service),
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
                                    widget.service.description,
                                    style: theme.textTheme.labelMedium?.copyWith(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 16),
                            SectionRatingDetailService(serviceId: widget.service.id),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                clipBehavior: Clip.antiAlias,
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
                        children: [
                          Text(
                            'Total',
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: theme.primaryColorDark,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.service.price,
                                style: theme.textTheme.labelMedium?.copyWith(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'XOF',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  fontSize: 14,
                                  color: theme.colorScheme.surface,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      CupertinoButton(
                          color: theme.primaryColor,
                          minSize: 0,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 20),
                          onPressed: () {
                            context.pushNamed(App.bookingService, extra: widget.service);
                          },
                          child: Row(
                            children: [
                              Icon(
                                CupertinoIcons.calendar_today,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                appLocalizations.book,
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
            ],
          ),
        ),
      ),
    );
  }
}
