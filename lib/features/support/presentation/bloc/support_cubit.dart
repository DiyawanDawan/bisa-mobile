import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

import '../../../../core/network/pusher_service.dart';
import '../../data/datasources/support_remote_data_source.dart';
import '../../data/models/support_ticket.dart';

part 'support_state.dart';
part 'support_cubit.freezed.dart';

class SupportCubit extends Cubit<SupportState> {
  SupportCubit(this._api) : super(const SupportState.initial());

  final SupportRemoteDataSource _api;
  bool _pusherSubscribed = false;
  String? _subscribedTicketId;

  Future<void> loadTicket(String ticketId, {bool showLoading = true}) async {
    if (showLoading) emit(const SupportState.loading());
    try {
      final ticket = await _api.getTicket(ticketId);
      emit(SupportState.loaded(ticket));
    } catch (e) {
      if (!showLoading && state is _Loaded) return;
      emit(SupportState.error(_mapError(e, 'support.load_error'.tr())));
    }
  }

  void subscribeToTicket(String ticketId) {
    _pusherSubscribed = true;
    _subscribedTicketId = ticketId;
    // SEC-MOB-004: private channel — hanya pemilik tiket / ADMIN yang lulus auth.
    PusherService().init(
      channelName: 'private-support-$ticketId',
      onEvent: (PusherEvent event) {
        if (_subscribedTicketId != ticketId) return;
        if (event.eventName == 'message.created' ||
            event.eventName == 'ticket.updated') {
          loadTicket(ticketId, showLoading: false);
        }
      },
    );
  }

  Future<bool> sendMessage(String ticketId, String content) async {
    final trimmed = content.trim();
    final current = state;
    if (trimmed.isEmpty || current is! _Loaded || current.isSending) {
      return false;
    }

    emit(SupportState.loaded(current.ticket, isSending: true));
    try {
      final ticket = await _api.sendMessage(ticketId, trimmed);
      emit(SupportState.loaded(ticket));
      return true;
    } catch (e) {
      emit(
        SupportState.loaded(
          current.ticket,
          actionError: _mapError(e, 'support.send_failed'.tr()),
        ),
      );
      return false;
    }
  }

  Future<void> closeTicket(String ticketId) async {
    final current = state;
    if (current is! _Loaded) return;
    try {
      final ticket = await _api.closeTicket(ticketId);
      emit(
        SupportState.loaded(ticket, notice: 'support.close_success'.tr()),
      );
    } catch (e) {
      emit(
        SupportState.loaded(
          current.ticket,
          actionError: _mapError(e, 'support.close_failed'.tr()),
        ),
      );
    }
  }

  String _mapError(Object error, String fallback) {
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map && data['message'] is String) {
        return data['message'] as String;
      }
    }
    return fallback;
  }

  @override
  Future<void> close() async {
    if (_pusherSubscribed && _subscribedTicketId != null) {
      await PusherService().unsubscribe(
        'private-support-$_subscribedTicketId',
      );
    }
    _pusherSubscribed = false;
    _subscribedTicketId = null;
    return super.close();
  }
}
