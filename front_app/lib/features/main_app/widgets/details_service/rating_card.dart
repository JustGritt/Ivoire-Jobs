import 'package:barassage_app/features/main_app/models/main/rating_model.dart';
import 'package:flutter/material.dart';

class RatingCard extends StatelessWidget {
  final Rating rating;

  RatingCard({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[200],
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: List.generate(5, (starIndex) {
                return Icon(
                  starIndex < rating.rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 20,
                );
              }),
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    rating.comment,
                    style: TextStyle(fontSize: 16.0),
                    overflow: TextOverflow.visible,
                  ),
                ),
                SizedBox(width: 8.0),
                Text(
                  rating.createdAt.toString(),
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Text(
              rating.firstname,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
