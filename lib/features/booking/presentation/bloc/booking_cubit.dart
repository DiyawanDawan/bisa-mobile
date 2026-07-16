import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/booking_entity.dart';
import '../../domain/repositories/booking_repository.dart';

class BookingState extends Equatable {
  final List<BookingEntity> bookings;
  final BookingEntity? selected;
  final bool isLoading;
  final bool isSubmitting;
  final String? error;

  const BookingState({
    this.bookings = const [],
    this.selected,
    this.isLoading = false,
    this.isSubmitting = false,
    this.error,
  });

  BookingState copyWith({
    List<BookingEntity>? bookings,
    BookingEntity? selected,
    bool? isLoading,
    bool? isSubmitting,
    String? error,
    bool clearError = false,
    bool clearSelected = false,
  }) {
    return BookingState(
      bookings: bookings ?? this.bookings,
      selected: clearSelected ? null : (selected ?? this.selected),
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [bookings, selected, isLoading, isSubmitting, error];
}

class BookingCubit extends Cubit<BookingState> {
  final BookingRepository _repository;

  BookingCubit(this._repository) : super(const BookingState());

  Future<void> loadMyBookings({String? status}) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    final result = await _repository.listMyBookings(status: status);
    result.fold(
      (f) => emit(state.copyWith(isLoading: false, error: f.message)),
      (list) => emit(state.copyWith(isLoading: false, bookings: list)),
    );
  }

  Future<void> loadIncomingBookings({String? status}) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    final result = await _repository.listIncomingBookings(status: status);
    result.fold(
      (f) => emit(state.copyWith(isLoading: false, error: f.message)),
      (list) => emit(state.copyWith(isLoading: false, bookings: list)),
    );
  }

  Future<void> loadDetail(String id) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    final result = await _repository.getBooking(id);
    result.fold(
      (f) => emit(state.copyWith(isLoading: false, error: f.message)),
      (b) => emit(state.copyWith(isLoading: false, selected: b)),
    );
  }

  Future<String?> createBooking(Map<String, dynamic> body) async {
    emit(state.copyWith(isSubmitting: true, clearError: true));
    final result = await _repository.createBooking(body);
    return result.fold(
      (f) {
        emit(state.copyWith(isSubmitting: false, error: f.message));
        return f.message;
      },
      (b) {
        emit(state.copyWith(
          isSubmitting: false,
          selected: b,
          bookings: [b, ...state.bookings],
        ));
        return null;
      },
    );
  }

  Future<String?> cancel(String id, {String? reason}) =>
      _action((_) => _repository.cancelBooking(id, reason: reason), id);

  Future<String?> confirm(String id) =>
      _action((_) => _repository.confirmBooking(id), id);

  Future<BookingCheckoutResult?> checkout(String id, {Map<String, dynamic>? body}) async {
    emit(state.copyWith(isSubmitting: true, clearError: true));
    final result = await _repository.checkoutBooking(id, body: body);
    return result.fold(
      (f) {
        emit(state.copyWith(isSubmitting: false, error: f.message));
        return null;
      },
      (checkoutResult) {
        final updated = state.bookings
            .map((e) => e.id == checkoutResult.booking.id ? checkoutResult.booking : e)
            .toList(growable: false);
        emit(state.copyWith(
          isSubmitting: false,
          selected: checkoutResult.booking,
          bookings: updated,
        ));
        return checkoutResult;
      },
    );
  }

  Future<String?> _action(
    Future<dynamic> Function(void _) call,
    String id,
  ) async {
    emit(state.copyWith(isSubmitting: true, clearError: true));
    final result = await call(null);
    return result.fold(
      (f) {
        emit(state.copyWith(isSubmitting: false, error: f.message));
        return f.message;
      },
      (BookingEntity b) {
        final updated = state.bookings
            .map((e) => e.id == b.id ? b : e)
            .toList(growable: false);
        emit(state.copyWith(isSubmitting: false, selected: b, bookings: updated));
        return null;
      },
    );
  }
}
