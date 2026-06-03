part of 'ai_cubit.dart';

@freezed
class AiState with _$AiState {
  const factory AiState.initial() = _Initial;
  const factory AiState.loading() = _Loading;
  const factory AiState.chatLoaded(List<ChatMessage> messages) = _ChatLoaded;
  const factory AiState.error(String message) = _Error;
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({required this.text, required this.isUser, required this.timestamp});
}
