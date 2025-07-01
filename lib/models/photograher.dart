class Photographer {
  final String id;
  final String name;
  final String email;
  final String? profileImage;
  final String? bio;
  final String location;
  final List<String> specialties;
  final double rating;
  final int reviewCount;
  final double hourlyRate;
  final bool isAvailable;
  final DateTime createdAt;

  Photographer({
    required this.id,
    required this.name,
    required this.email,
    this.profileImage,
    this.bio,
    required this.location,
    required this.specialties,
    required this.rating,
    required this.reviewCount,
    required this.hourlyRate,
    required this.isAvailable,
    required this.createdAt,
  });

  factory Photographer.fromJson(Map<String, dynamic> json) {
    return Photographer(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      profileImage: json['profile_image'],
      bio: json['bio'],
      location: json['location'],
      specialties: List<String>.from(json['specialties'] ?? []),
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviewCount: json['review_count'] ?? 0,
      hourlyRate: (json['hourly_rate'] ?? 0.0).toDouble(),
      isAvailable: json['is_available'] ?? true,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profile_image': profileImage,
      'bio': bio,
      'location': location,
      'specialties': specialties,
      'rating': rating,
      'review_count': reviewCount,
      'hourly_rate': hourlyRate,
      'is_available': isAvailable,
      'created_at': createdAt.toIso8601String(),
    };
  }
}