import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/i18n/tr_safe.dart';
import '../../../../core/i18n/failure_messages.dart';
import '../../../../core/utils/batch_weight_util.dart';
import '../../../../injection_container.dart';
import '../../../marketplace/presentation/utils/prediction_product_mapper.dart';
import '../../../ai/presentation/widgets/predict_quality_sheet.dart';
import '../../../ai/presentation/widgets/predict_result_table.dart';
import '../../../../shared/widgets/batch_weight_field.dart';
import '../../domain/repositories/iot_repository.dart';

class IotRealtimePanel extends StatefulWidget {
  const IotRealtimePanel({
    super.key,
    required this.deviceId,
    this.lastTemperature,
    this.enabled = true,
    this.onAnalysisComplete,
  });

  final String deviceId;
  final double? lastTemperature;
  final bool enabled;
  final VoidCallback? onAnalysisComplete;

  @override
  State<IotRealtimePanel> createState() => _IotRealtimePanelState();
}

class _IotRealtimePanelState extends State<IotRealtimePanel> {
  static const _biomassaTypes = [
    'SEKAM_PADI',
    'TONGKOL_JAGUNG',
    'TEMPURUNG_KELAPA',
    'WOOD_CHIP',
    'OTHER',
  ];

  String _biomassaType = 'SEKAM_PADI';
  final _beratCtrl = TextEditingController(text: '${BatchWeightUtil.defaultBatchTon}');
  BatchWeightUnit _weightUnit = BatchWeightUnit.ton;
  bool _loading = false;
  bool _sessionActive = false;
  int _elapsedMinutes = 0;
  Map<String, dynamic>? _lastAnalysis;
  String? _error;
  Timer? _pollTimer;

  @override
  void initState() {
    super.initState();
    _loadSession();
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _beratCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadSession() async {
    if (!widget.enabled) return;
    final result = await sl<IotRepository>().getPyrolysisSession(widget.deviceId);
    if (!mounted) return;
    result.fold((_) {}, (session) {
      setState(() {
        _sessionActive = session != null;
        _elapsedMinutes = session?['elapsedMinutes'] as int? ?? 0;
        if (session?['biomassaType'] != null) {
          _biomassaType = session!['biomassaType'].toString();
        }
        if (session?['beratInput'] != null) {
          final kg = session!['beratInput'] as num;
          _weightUnit = BatchWeightUtil.preferredUnitForKg(kg);
          _beratCtrl.text = _weightUnit.formatFromKgNullable(kg);
        }
      });
      if (_sessionActive) _startPolling();
    });
  }

  void _startPolling() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 45), (_) {
      _analyze(silent: true);
      _loadSession();
    });
  }

  void _stopPolling() {
    _pollTimer?.cancel();
    _pollTimer = null;
  }

  Future<void> _startSession() async {
    final beratKg = BatchWeightUtil.parseFieldToKg(_beratCtrl.text, _weightUnit);
    if (beratKg == null) {
      setState(() => _error = 'iot.realtime_invalid_weight'.tr());
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    final result = await sl<IotRepository>().startPyrolysisSession(
      widget.deviceId,
      biomassaType: _biomassaType,
      beratInput: beratKg,
    );
    if (!mounted) return;
    result.fold(
      (f) => setState(() {
        _loading = false;
        _error = localizeFailureMessage(f.message);
      }),
      (_) async {
        await _loadSession();
        if (mounted) setState(() => _loading = false);
        _startPolling();
      },
    );
  }

  Future<void> _stopSession() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    _stopPolling();
    final result = await sl<IotRepository>().stopPyrolysisSession(widget.deviceId);
    if (!mounted) return;
    result.fold(
      (f) => setState(() {
        _loading = false;
        _error = localizeFailureMessage(f.message);
      }),
      (_) => setState(() {
        _loading = false;
        _sessionActive = false;
        _elapsedMinutes = 0;
      }),
    );
  }

  Future<void> _analyze({bool silent = false}) async {
    if (!silent) {
      setState(() {
        _loading = true;
        _error = null;
      });
    }
    final result = await sl<IotRepository>().analyzeRealtime(widget.deviceId);
    if (!mounted) return;
    result.fold(
      (f) {
        if (!silent) {
          setState(() {
            _loading = false;
            _error = localizeFailureMessage(f.message);
          });
        } else if (f.message.contains('sensor') || f.message.contains('suhu')) {
          setState(() => _error = trSafe(
                'iot.realtime_no_sensor',
                fallback:
                    'Belum ada data suhu dari sensor. Pastikan ESP32 mengirim ke server, lalu tap Analisis lagi.',
              ));
        }
      },
      (data) {
        final session = data['session'] as Map<String, dynamic>?;
        setState(() {
          if (!silent) _loading = false;
          _lastAnalysis = data;
          _sessionActive = session != null;
          _elapsedMinutes = session?['elapsedMinutes'] as int? ?? _elapsedMinutes;
        });
        widget.onAnalysisComplete?.call();
      },
    );
  }

  void _openManualPredict() {
    final inputs = _lastAnalysis?['inputs'] as Map<String, dynamic>?;
    final telemetry = _lastAnalysis?['telemetry'] as Map<String, dynamic>?;
    final suhu = inputs?['suhuPirolisis'] ??
        telemetry?['avgTemp'] ??
        telemetry?['currentTemp'] ??
        widget.lastTemperature;
    final waktu = inputs?['waktuPembakaran'] ?? (_sessionActive ? _elapsedMinutes : null);
    final beratKg = BatchWeightUtil.parseFieldToKg(_beratCtrl.text, _weightUnit);

    PredictQualitySheet.show(
      context,
      initialBiomassaType: _biomassaType,
      initialSuhu: suhu is num ? suhu.toDouble() : widget.lastTemperature,
      initialWaktu: waktu is num ? waktu.toDouble() : null,
      initialBerat: beratKg,
    );
  }

  Widget _buildPredictionCard(Map<String, dynamic> prediction) {
    final inputs = _lastAnalysis?['inputs'] as Map<String, dynamic>?;
    return PredictResultTable(
      prediction: prediction,
      compact: true,
      onAddToProduct: prediction['id'] == null
          ? null
          : () => openAddProductFromPrediction(
                context,
                prediction: prediction,
                inputs: inputs,
              ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return const SizedBox.shrink();

    final prediction = _lastAnalysis?['prediction'] as Map<String, dynamic>?;
    final telemetry = _lastAnalysis?['telemetry'] as Map<String, dynamic>?;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.activity, size: 16.sp, color: AppColors.primary),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  'iot.realtime_title'.tr(),
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w800),
                ),
              ),
              if (_sessionActive)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    'iot.realtime_session_active'.tr(
                      namedArgs: {'minutes': '$_elapsedMinutes'},
                    ),
                    style: TextStyle(fontSize: 10.sp, color: AppColors.success),
                  ),
                ),
            ],
          ),
          if (!_sessionActive) ...[
            SizedBox(height: 8.h),
            Wrap(
              spacing: 4.w,
              runSpacing: 4.h,
              children: _biomassaTypes.map((t) {
                final selected = _biomassaType == t;
                return ChoiceChip(
                  label: Text(
                    t.replaceAll('_', ' '),
                    style: TextStyle(fontSize: 10.sp),
                  ),
                  labelPadding: EdgeInsets.symmetric(horizontal: 4.w),
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  selected: selected,
                  onSelected: (_) => setState(() => _biomassaType = t),
                  selectedColor: AppColors.primaryLight,
                );
              }).toList(),
            ),
            SizedBox(height: 6.h),
            BatchWeightField(
              controller: _beratCtrl,
              initialUnit: _weightUnit,
              onUnitChanged: (u) => setState(() => _weightUnit = u),
            ),
          ],
          if (_error != null) ...[
            SizedBox(height: 6.h),
            Text(_error!, style: TextStyle(fontSize: 10.sp, color: AppColors.error)),
          ],
          if (telemetry != null) ...[
            SizedBox(height: 6.h),
            Text(
              'iot.realtime_telemetry'.tr(
                namedArgs: {
                  'avg': '${telemetry['avgTemp'] ?? '—'}',
                  'current': '${telemetry['currentTemp'] ?? widget.lastTemperature?.toStringAsFixed(1) ?? '—'}',
                  'count': '${telemetry['readingCount'] ?? 0}',
                },
              ),
              style: TextStyle(fontSize: 10.sp, color: AppColors.textSecondary),
            ),
          ],
          if (prediction != null) ...[
            SizedBox(height: 8.h),
            _buildPredictionCard(prediction),
          ] else if (!_loading && _lastAnalysis == null) ...[
            SizedBox(height: 6.h),
            Text(
              trSafe(
                'iot.realtime_no_result_yet',
                fallback: 'Tap Analisis setelah sesi dimulai & sensor aktif.',
              ),
              style: TextStyle(fontSize: 10.sp, color: AppColors.textSecondary),
            ),
          ],
          SizedBox(height: 8.h),
          Row(
            children: [
              if (!_sessionActive)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _loading ? null : _startSession,
                    icon: Icon(LucideIcons.play, size: 14.sp),
                    label: Text('iot.realtime_start'.tr(), style: TextStyle(fontSize: 12.sp)),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                )
              else
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _loading ? null : _stopSession,
                    icon: Icon(LucideIcons.square, size: 14.sp),
                    label: Text('iot.realtime_stop'.tr(), style: TextStyle(fontSize: 12.sp)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ),
              SizedBox(width: 6.w),
              Expanded(
                child: FilledButton.icon(
                  onPressed: _loading ? null : () => _analyze(),
                  icon: _loading
                      ? SizedBox(
                          width: 12.w,
                          height: 12.w,
                          child: const CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(LucideIcons.sparkles, size: 14.sp),
                  label: Text('iot.realtime_analyze'.tr(), style: TextStyle(fontSize: 12.sp)),
                  style: FilledButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: _openManualPredict,
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'iot.realtime_manual_predict'.tr(),
                style: TextStyle(fontSize: 11.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
