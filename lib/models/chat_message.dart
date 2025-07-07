import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
  });

  Map<String, dynamic> toMap(String userId) {
    return {
      'userId': userId,
      'text': text,
      'isUser': isUser,
      'timestamp': timestamp,
    };
  }

  factory ChatMessage.fromMap(String id, Map<String, dynamic> map) {
    return ChatMessage(
      id: id,
      text: map['text'] ?? '',
      isUser: map['isUser'] ?? true,
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }
}
