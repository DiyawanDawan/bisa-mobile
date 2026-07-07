import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/repositories/ai_repository.dart';

part 'ai_state.dart';
part 'ai_cubit.freezed.dart';

class AiCubit extends HydratedCubit<AiState> {
  final AiRepository _repository;
  List<ChatMessage> _messages = [];

  AiCubit(this._repository) : super(const AiState.initial());

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    _messages.add(ChatMessage(text: text, isUser: true, timestamp: DateTime.now()));
    emit(AiState.chatLoaded(List.from(_messages), isTyping: true));

    final result = await _repository.askChatbot(text);
    result.fold(
      (failure) {
        emit(AiState.chatLoaded(List.from(_messages), isTyping: false));
        emit(AiState.error(failure.message));
      },
      (answer) {
        _messages.add(ChatMessage(text: _stripMarkdown(answer), isUser: false, timestamp: DateTime.now()));
        emit(AiState.chatLoaded(List.from(_messages)));
      },
    );
  }

  void deleteMessage(String id) {
    _messages.removeWhere((msg) => msg.id == id);
    if (_messages.isEmpty) {
      emit(const AiState.initial());
    } else {
      emit(AiState.chatLoaded(List.from(_messages), isTyping: false));
    }
  }

  void editMessage(String id, String newText) {
    final index = _messages.indexWhere((msg) => msg.id == id);
    if (index != -1) {
      final oldMsg = _messages[index];
      _messages[index] = ChatMessage(
        id: oldMsg.id,
        text: oldMsg.isUser ? newText : _stripMarkdown(newText),
        isUser: oldMsg.isUser,
        timestamp: oldMsg.timestamp,
      );
      emit(AiState.chatLoaded(List.from(_messages), isTyping: false));
    }
  }

  void clearChat() {
    _messages.clear();
    emit(const AiState.initial());
  }

  /// Remove any leftover markdown formatting (**, *, #, `) from AI text.
  String _stripMarkdown(String text) {
    return text
        .replaceAll(RegExp(r'\*\*(.+?)\*\*'), r'$1')
        .replaceAll(RegExp(r'\*(.+?)\*'), r'$1')
        .replaceAll(RegExp(r'^#{1,6}\s+', multiLine: true), '')
        .replaceAll(RegExp(r'`(.+?)`'), r'$1')
        .trim();
  }

  @override
  AiState? fromJson(Map<String, dynamic> json) {
    try {
      final List<dynamic> msgsJson = json['messages'] as List<dynamic>;
      _messages = msgsJson.map((m) {
        return ChatMessage(
          id: m['id'] as String?,
          text: m['text'] as String,
          isUser: m['isUser'] as bool,
          timestamp: DateTime.parse(m['timestamp'] as String),
        );
      }).toList();
      if (_messages.isEmpty) {
        return const AiState.initial();
      }
      return AiState.chatLoaded(List.from(_messages), isTyping: false);
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(AiState state) {
    return {
      'messages': _messages.map((m) => {
        'id': m.id,
        'text': m.text,
        'isUser': m.isUser,
        'timestamp': m.timestamp.toIso8601String(),
      }).toList(),
    };
  }
}

