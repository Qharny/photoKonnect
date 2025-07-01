import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseClient _client = Supabase.instance.client;

  static SupabaseClient get client => _client;

  // Auth methods
  static Future<AuthResponse> signUp({
    required String email,
    required String password,
    Map<String, dynamic>? data,
  }) async {
    return await _client.auth.signUp(
      email: email,
      password: password,
      data: data,
    );
  }

  static Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  static Future<void> signOut() async {
    await _client.auth.signOut();
  }

  static User? get currentUser => _client.auth.currentUser;

  static Stream<AuthState> get authStateStream => _client.auth.onAuthStateChange;

  // Photographer methods
  static Future<List<Map<String, dynamic>>> getPhotographers() async {
    final response = await _client
        .from('photographers')
        .select('*, portfolios(*), reviews(*)')
        .order('rating', ascending: false);
    return response;
  }

  // Booking methods
  static Future<Map<String, dynamic>> createBooking({
    required String photographerId,
    required DateTime bookingDate,
    required String serviceType,
    required double price,
    String? notes,
  }) async {
    final response = await _client.from('bookings').insert({
      'client_id': currentUser?.id,
      'photographer_id': photographerId,
      'booking_date': bookingDate.toIso8601String(),
      'service_type': serviceType,
      'price': price,
      'notes': notes,
      'status': 'pending',
    }).select().single();
    return response;
  }

  // Portfolio methods
  static Future<List<Map<String, dynamic>>> getPortfolioImages(String photographerId) async {
    final response = await _client
        .from('portfolio_images')
        .select('*')
        .eq('photographer_id', photographerId)
        .order('created_at', ascending: false);
    return response;
  }
}