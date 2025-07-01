enum BookingStatus { pending, confirmed, completed, cancelled }

class Booking {
  final String id;
  final String clientId;
  final String photographerId;
  final DateTime bookingDate;
  final String serviceType;
  final double price;
  final String? notes;
  final BookingStatus status;
  final DateTime createdAt;

  Booking({
    required this.id,
    required this.clientId,
    required this.photographerId,
    required this.bookingDate,
    required this.serviceType,
    required this.price,
    this.notes,
    required this.status,
    required this.createdAt,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      clientId: json['client_id'],
      photographerId: json['photographer_id'],
      bookingDate: DateTime.parse(json['booking_date']),
      serviceType: json['service_type'],
      price: (json['price'] ?? 0.0).toDouble(),
      notes: json['notes'],
      status: BookingStatus.values.firstWhere(
            (status) => status.name == json['status'],
        orElse: () => BookingStatus.pending,
      ),
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}