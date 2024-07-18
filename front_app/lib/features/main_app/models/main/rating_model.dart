class Rating {
  final String id;
  final String serviceId;
  final double rating;
  final String comment;
  final String firstname;
  final String createdAt;
  final bool status;
  final double score;

  Rating({
    required this.id,
    required this.serviceId,
    required this.rating,
    required this.comment,
    required this.firstname,
    required this.createdAt,
    required this.status,
    required this.score,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      id: json['id'],
      serviceId: json['serviceId'],
      rating: (json['rating'] is int) ? (json['rating'] as int).toDouble() : json['rating'],
      comment: json['comment'],
      firstname: json['firstname'],
      createdAt: json['createdAt'],
      status: json['status'],
      score: (json['score'] is int) ? (json['score'] as int).toDouble() : json['score'],
    );
  }
}
