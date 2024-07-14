import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:barassage_app/features/main_app/providers/ratings_provider.dart';
import 'package:barassage_app/features/main_app/models/main/rating_model.dart';

class SectionRatingDetailService extends StatefulWidget {
  final String serviceId;

  SectionRatingDetailService({required this.serviceId});

  @override
  _SectionRatingDetailServiceState createState() => _SectionRatingDetailServiceState();
}

class _SectionRatingDetailServiceState extends State<SectionRatingDetailService> {
  Future<List<Rating>>? futureRatings;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ratingsProvider = Provider.of<RatingsProvider>(context, listen: false);
      setState(() {
        futureRatings = ratingsProvider.getServiceRatings(widget.serviceId);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Rating>>(
      future: futureRatings,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data!.isEmpty) {
          return const Center(child: Text('No ratings yet'));
        } else if (snapshot.hasData) {
          List<Rating> ratings = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Ratings',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: ratings.length,
                itemBuilder: (context, index) {
                  final rating = ratings[index];
                  return ListTile(
                    title: Text(rating.comment),
                    subtitle: Text('User ID: ${rating.userId}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(5, (starIndex) {
                        return Icon(
                          starIndex < rating.rating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 20,
                        );
                      }),
                    ),
                  );
                },
              ),
            ],
          );
        }
        return const Center(child: Text('No ratings available.'));
      },
    );
  }
}
