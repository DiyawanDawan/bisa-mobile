import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failures.dart';
import '../../data/iot_device_cache.dart';
import '../../domain/repositories/iot_repository.dart';
import '../../domain/entities/iot_dashboard_entity.dart';
import '../../data/models/iot_device_model.dart';

part 'iot_state.dart';
part 'iot_cubit.freezed.dart';

class IotCubit extends Cubit<IotState> {
  final IotRepository _repository;
  final IotDeviceCache _cache;

  IotCubit(this._repository, this._cache) : super(const IotState.initial());

  Future<void> getDevices({bool withFleet = true}) async {
    final cached = await _cache.loadDevices();
    if (cached != null && cached.isNotEmpty) {
      emit(IotState.loaded(cached));
    } else {
      emit(const IotState.loading());
    }

    final devicesResult = await _repository.getDevices();
    IotFleetAnalyticsEntity? fleet;
    IotStatusSummaryEntity? statusSummary;
    if (withFleet) {
      final fleetResult = await _repository.getFleetAnalytics();
      fleetResult.fold((_) {}, (f) => fleet = f);
      final summaryResult = await _repository.getStatusSummary(limit: 100);
      summaryResult.fold((_) {}, (s) => statusSummary = s);
    }

    devicesResult.fold(
      (failure) {
        if (cached == null || cached.isEmpty) {
          emit(IotState.error(failure.message));
        }
      },
      (devices) async {
        await _cache.saveDevices(devices);
        emit(IotState.loaded(devices, fleet: fleet, statusSummary: statusSummary));
      },
    );
  }

  Future<void> updateDeviceSettings(
    String deviceId,
    Map<String, dynamic> data, {
    String range = '24h',
  }) async {
    final result = await _repository.updateDevice(deviceId, data);
    result.fold(
      (failure) => emit(IotState.error(failure.message)),
      (_) => getDeviceDashboard(deviceId, range: range),
    );
  }

  Future<Either<Failure, String>> exportReadings(
    String deviceId, {
    String range = '24h',
  }) {
    return _repository.exportDeviceReadingsCsv(deviceId, range: range);
  }

  Future<void> claimDevice(String deviceSecret, String name) async {
    emit(const IotState.loading());
    final result = await _repository.claimDevice(deviceSecret, name);
    result.fold(
      (failure) => emit(IotState.error(failure.message)),
      (_) => getDevices(),
    );
  }

  Future<void> getDeviceDashboard(String deviceId, {String range = '24h'}) async {
    final previous = state;
    if (previous is _DashboardLoaded) {
      emit(IotState.dashboardLoaded(previous.dashboard, range: range, alertsLoading: true));
    } else {
      emit(const IotState.loading());
    }

    final result = await _repository.getDeviceDashboard(deviceId, range: range);
    result.fold(
      (failure) => emit(IotState.error(failure.message)),
      (dashboard) async {
        final alertsResult = await _repository.getDeviceAlerts(deviceId, limit: 30);
        final alertsPage = alertsResult.fold((_) => null, (a) => a);
        emit(IotState.dashboardLoaded(
          dashboard,
          range: range,
          alertsPage: alertsPage,
        ));
      },
    );
  }

  Future<void> loadDeviceAlerts(String deviceId, {int page = 1}) async {
    final previous = state;
    if (previous is! _DashboardLoaded) return;

    emit(previous.copyWith(alertsLoading: true));
    final result = await _repository.getDeviceAlerts(deviceId, page: page, limit: 30);
    result.fold(
      (failure) => emit(IotState.error(failure.message)),
      (alertsPage) => emit(previous.copyWith(
        alertsPage: alertsPage,
        alertsLoading: false,
      )),
    );
  }

  Future<void> markAlertRead(String deviceId, String alertId) async {
    var range = '24h';
    state.maybeWhen(
      dashboardLoaded: (_, r, __, ___) => range = r,
      orElse: () {},
    );
    final result = await _repository.markAlertRead(alertId);
    result.fold(
      (failure) => emit(IotState.error(failure.message)),
      (_) => getDeviceDashboard(deviceId, range: range),
    );
  }

  Future<void> updateDevice(String deviceId, Map<String, dynamic> data) async {
    emit(const IotState.loading());
    final result = await _repository.updateDevice(deviceId, data);
    result.fold(
      (failure) => emit(IotState.error(failure.message)),
      (_) => getDevices(),
    );
  }

  Future<void> setMonitoringEnabled(String deviceId, bool enabled) async {
    final previous = state;
    final result = await _repository.updateDevice(deviceId, {
      'status': enabled ? 'ACTIVE' : 'INACTIVE',
    });
    result.fold(
      (failure) => emit(IotState.error(failure.message)),
      (_) async {
        if (previous is _Loaded) {
          final updated = previous.devices.map((d) {
            if (d.id != deviceId) return d;
            return d.copyWith(
              isMonitoringEnabled: enabled,
              monitoringStatus: enabled ? 'ACTIVE' : 'INACTIVE',
              status: enabled ? 'OFFLINE' : 'DISABLED',
            );
          }).toList();
          await _cache.saveDevices(updated);
          emit(IotState.loaded(
            updated,
            fleet: previous.fleet,
            statusSummary: previous.statusSummary,
          ));
        } else if (previous is _DashboardLoaded) {
          await getDeviceDashboard(deviceId);
        } else {
          getDevices();
        }
      },
    );
  }

  Future<void> deleteDevice(String deviceId, {bool refreshList = true}) async {
    emit(const IotState.loading());
    final result = await _repository.deleteDevice(deviceId);
    result.fold(
      (failure) => emit(IotState.error(failure.message)),
      (_) {
        if (refreshList) {
          getDevices();
        }
      },
    );
  }

  Future<void> subscribePro(String channelCode, String method) async {
    emit(const IotState.loading());
    final result = await _repository.subscribePro(channelCode, method);
    result.fold(
      (failure) => emit(IotState.error(failure.message)),
      (data) => emit(IotState.subscriptionSuccess(data)),
    );
  }
}
