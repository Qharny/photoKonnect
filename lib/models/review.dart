class Review {
  final String id;
  final String clientId;
  final String photographerId;
  final double rating;
  final String? comment;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.clientId,
    required this.photographerId,
    required this.rating,
    this.comment,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      clientId: json['client_id'],
      photographerId: json['photographer_id'],
      rating: (json['rating'] ?? 0.0).toDouble(),
      comment: json['comment'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}