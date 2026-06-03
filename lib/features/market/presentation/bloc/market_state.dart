part of 'market_cubit.dart';

@freezed
class MarketState with _$MarketState {
  const factory MarketState.initial() = _Initial;
  const factory MarketState.loading() = _Loading;
  const factory MarketState.loaded(List<MarketTrendModel> trends) = _Loaded;
  const factory MarketState.predictionLoaded(MarketTrendModel prediction) = _PredictionLoaded;
  const factory MarketState.error(String message) = _Error;
}
