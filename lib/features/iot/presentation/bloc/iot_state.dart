part of 'iot_cubit.dart';

@freezed
class IotState with _$IotState {
  const factory IotState.initial() = _Initial;
  const factory IotState.loading() = _Loading;
  const factory IotState.loaded(
    List<IotDeviceModel> devices, {
    IotFleetAnalyticsEntity? fleet,
    IotStatusSummaryEntity? statusSummary,
  }) = _Loaded;
  const factory IotState.dashboardLoaded(
    IotDashboardEntity dashboard, {
    @Default('24h') String range,
    IotAlertsPageEntity? alertsPage,
    @Default(false) bool alertsLoading,
  }) = _DashboardLoaded;
  const factory IotState.subscriptionSuccess(Map<String, dynamic> data) = _SubscriptionSuccess;
  const factory IotState.error(String message) = _Error;
}
