import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/repositories/ai_repository.dart';

part 'ai_state.dart';
part 'ai_cubit.freezed.dart';

class AiCubit extends Cubit<AiState> {
  final AiRepository _repository;
  final List<ChatMessage> _messages = [];

  AiCubit(this._repository) : super(const AiState.initial());

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    _messages.add(ChatMessage(text: text, isUser: true, timestamp: DateTime.now()));
    emit(AiState.chatLoaded(List.from(_messages)));

    final result = await _repository.askChatbot(text);
    result.fold(
      (failure) => emit(AiState.error(failure.message)),
      (answer) {
        _messages.add(ChatMessage(text: answer, isUser: false, timestamp: DateTime.now()));
        emit(AiState.chatLoaded(List.from(_messages)));
      },
    );
  }
}
