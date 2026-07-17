class SupportUser {
  const SupportUser({
    required this.id,
    required this.fullName,
    required this.role,
    this.email,
    this.avatarUrl,
  });

  final String id;
  final String fullName;
  final String role;
  final String? email;
  final String? avatarUrl;

  factory SupportUser.fromJson(Map<String, dynamic> json) => SupportUser(
    id: json['id']?.toString() ?? '',
    fullName: json['fullName']?.toString() ?? '',
    role: json['role']?.toString() ?? '',
    email: json['email']?.toString(),
    avatarUrl: json['avatarUrl']?.toString(),
  );
}

class SupportMessage {
  const SupportMessage({
    required this.id,
    required this.senderType,
    required this.content,
    required this.createdAt,
    this.sender,
  });

  final String id;
  final String senderType;
  final String content;
  final DateTime createdAt;
  final SupportUser? sender;

  factory SupportMessage.fromJson(Map<String, dynamic> json) => SupportMessage(
    id: json['id']?.toString() ?? '',
    senderType: json['senderType']?.toString() ?? 'SYSTEM',
    content: json['content']?.toString() ?? '',
    createdAt:
        DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
        DateTime.now(),
    sender: json['sender'] is Map
        ? SupportUser.fromJson(Map<String, dynamic>.from(json['sender'] as Map))
        : null,
  );
}

class SupportTicket {
  const SupportTicket({
    required this.id,
    required this.subject,
    required this.status,
    required this.category,
    required this.priority,
    required this.source,
    required this.createdAt,
    required this.updatedAt,
    this.assignedAdmin,
    this.messages = const [],
    this.messageCount = 0,
  });

  final String id;
  final String subject;
  final String status;
  final String category;
  final String priority;
  final String source;
  final DateTime createdAt;
  final DateTime updatedAt;
  final SupportUser? assignedAdmin;
  final List<SupportMessage> messages;
  final int messageCount;

  bool get isActive =>
      const {'OPEN', 'ASSIGNED', 'WAITING_USER'}.contains(status);

  factory SupportTicket.fromJson(Map<String, dynamic> json) {
    final rawMessages = json['messages'] as List? ?? const [];
    return SupportTicket(
      id: json['id']?.toString() ?? '',
      subject: json['subject']?.toString() ?? '',
      status: json['status']?.toString() ?? 'OPEN',
      category: json['category']?.toString() ?? 'OTHER',
      priority: json['priority']?.toString() ?? 'NORMAL',
      source: json['source']?.toString() ?? 'HELP_CENTER',
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      updatedAt:
          DateTime.tryParse(json['updatedAt']?.toString() ?? '') ??
          DateTime.now(),
      assignedAdmin: json['assignedAdmin'] is Map
          ? SupportUser.fromJson(
              Map<String, dynamic>.from(json['assignedAdmin'] as Map),
            )
          : null,
      messages: rawMessages
          .whereType<Map>()
          .map(
            (message) =>
                SupportMessage.fromJson(Map<String, dynamic>.from(message)),
          )
          .toList(),
      messageCount:
          (json['_count'] as Map?)?['messages'] as int? ?? rawMessages.length,
    );
  }
}
