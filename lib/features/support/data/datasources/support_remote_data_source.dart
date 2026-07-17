import 'package:dio/dio.dart';
import '../models/support_ticket.dart';

class SupportRemoteDataSource {
  SupportRemoteDataSource(this._dio);

  final Dio _dio;

  Future<SupportTicket?> getActiveTicket() async {
    final response = await _dio.get('/support/tickets/active');
    final raw = response.data['data']?['ticket'];
    if (raw is! Map) return null;
    return SupportTicket.fromJson(Map<String, dynamic>.from(raw));
  }

  Future<List<SupportTicket>> listTickets() async {
    final response = await _dio.get('/support/tickets');
    final raw = response.data['data']?['tickets'] as List? ?? const [];
    return raw
        .whereType<Map>()
        .map(
          (ticket) => SupportTicket.fromJson(Map<String, dynamic>.from(ticket)),
        )
        .toList();
  }

  Future<SupportTicket> getTicket(String id) async {
    final response = await _dio.get('/support/tickets/$id');
    return SupportTicket.fromJson(
      Map<String, dynamic>.from(response.data['data'] as Map),
    );
  }

  Future<SupportTicket> createTicket({
    required String subject,
    required String category,
    required String source,
    String? initialMessage,
    List<Map<String, String>>? aiTranscript,
  }) async {
    final response = await _dio.post(
      '/support/tickets',
      data: {
        'subject': subject,
        'category': category,
        'source': source,
        if (initialMessage?.trim().isNotEmpty == true)
          'initialMessage': initialMessage!.trim(),
        if (aiTranscript?.isNotEmpty == true) 'aiTranscript': aiTranscript,
      },
    );
    return SupportTicket.fromJson(
      Map<String, dynamic>.from(response.data['data'] as Map),
    );
  }

  Future<SupportTicket> sendMessage(String ticketId, String content) async {
    final response = await _dio.post(
      '/support/tickets/$ticketId/messages',
      data: {'content': content},
    );
    return SupportTicket.fromJson(
      Map<String, dynamic>.from(response.data['data'] as Map),
    );
  }

  Future<SupportTicket> closeTicket(String ticketId) async {
    final response = await _dio.post('/support/tickets/$ticketId/close');
    return SupportTicket.fromJson(
      Map<String, dynamic>.from(response.data['data'] as Map),
    );
  }
}
