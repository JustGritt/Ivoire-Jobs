class Rating {
  final String id;
  final String serviceId;
  final int rating;
  final String comment;
  final String userId;
  final String createdAt;
  final bool status;
  final int score;

  Rating({
    required this.id,
    required this.serviceId,
    required this.rating,
    required this.comment,
    required this.userId,
    required this.createdAt,
    required this.status,
    required this.score,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      id: json['id'],
      serviceId: json['serviceId'],
      rating: json['rating'],
      comment: json['comment'],
      userId: json['userId'],
      createdAt: json['createdAt'],
      status: json['status'],
      score: json['score'],
    );
  }
}
