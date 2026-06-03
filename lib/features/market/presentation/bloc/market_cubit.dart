import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/market_repository.dart';
import '../../data/models/market_trend_model.dart';

part 'market_state.dart';
part 'market_cubit.freezed.dart';

class MarketCubit extends Cubit<MarketState> {
  final MarketRepository _repository;

  MarketCubit(this._repository) : super(const MarketState.initial());

  Future<void> getMarketTrends({String? category}) async {
    emit(const MarketState.loading());
    final result = await _repository.getMarketTrends(category: category);
    result.fold(
      (failure) => emit(MarketState.error(failure.message)),
      (trends) => emit(MarketState.loaded(trends)),
    );
  }

  Future<void> getPrediction(String id) async {
    emit(const MarketState.loading());
    final result = await _repository.getPrediction(id);
    result.fold(
      (failure) => emit(MarketState.error(failure.message)),
      (prediction) => emit(MarketState.predictionLoaded(prediction)),
    );
  }
}
