import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart'
    as mlkit;
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/core/constants/app_layout.dart';
import 'package:mobile_bisa/core/utils/digital_ink_util.dart';

/// Bottom-sheet canvas untuk input tulisan tangan.
///
/// User menggambar dengan jari/stylus di atas canvas.
/// Setelah menggambar, tap [Kenali] untuk menjalankan ML Kit Digital Ink
/// Recognition dan mendapatkan teks yang dikenali.
/// Hasil dikembalikan melalui callback [onResult].
class HandwritingInputSheet extends StatefulWidget {
  const HandwritingInputSheet({super.key, required this.onResult});

  /// Dipanggil ketika recognition berhasil — argumen adalah teks hasil.
  final void Function(String text) onResult;

  @override
  State<HandwritingInputSheet> createState() => _HandwritingInputSheetState();
}

class _HandwritingInputSheetState extends State<HandwritingInputSheet> {
  final List<mlkit.StrokePoint> _currentStroke = [];
  final List<List<mlkit.StrokePoint>> _allStrokes = [];

  bool _isRecognizing = false;
  bool _isDownloadingModel = false;
  String? _errorMessage;

  /// Konversi strokes ke [mlkit.Ink] yang dibutuhkan ML Kit.
  mlkit.Ink _buildInk() {
    final strokes = _allStrokes.map((points) {
      final s = mlkit.Stroke();
      s.points = points
          .map((p) => mlkit.StrokePoint(x: p.x, y: p.y, t: p.t))
          .toList();
      return s;
    }).toList();
    return mlkit.Ink()..strokes = strokes;
  }

  Future<void> _recognize() async {
    if (_allStrokes.isEmpty) return;

    setState(() {
      _isRecognizing = true;
      _errorMessage = null;
    });

    final candidates = await DigitalInkUtil.recognize(_buildInk());

    if (!mounted) return;

    if (candidates.isEmpty) {
      setState(() {
        _isRecognizing = false;
        _errorMessage = 'negotiation.handwriting_no_result'.tr();
      });
      return;
    }

    setState(() => _isRecognizing = false);
    widget.onResult(candidates.first);
    if (mounted) Navigator.pop(context);
  }

  void _clear() {
    setState(() {
      _currentStroke.clear();
      _allStrokes.clear();
      _errorMessage = null;
    });
  }

  @override
  void initState() {
    super.initState();
    _ensureModel();
  }

  Future<void> _ensureModel() async {
    setState(() => _isDownloadingModel = true);
    await DigitalInkUtil.downloadModelIfNeeded();
    if (mounted) setState(() => _isDownloadingModel = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40.w,
            height: 4.h,
            margin: EdgeInsets.only(bottom: 12.h),
            decoration: BoxDecoration(
              color: AppColors.grey300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Title
          Text(
            'negotiation.handwriting_title'.tr(),
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'negotiation.handwriting_hint'.tr(),
            style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
          ),
          SizedBox(height: 12.h),

          // Canvas or loading
          if (_isDownloadingModel)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 24.h),
              child: Column(
                children: [
                  const CircularProgressIndicator(),
                  SizedBox(height: 8.h),
                  Text(
                    'negotiation.handwriting_downloading_model'.tr(),
                    style: TextStyle(
                        fontSize: 12.sp, color: AppColors.textSecondary),
                  ),
                ],
              ),
            )
          else
            _buildCanvas(),

          // Error message
          if (_errorMessage != null)
            Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: Text(
                _errorMessage!,
                style: TextStyle(fontSize: 12.sp, color: AppColors.error),
                textAlign: TextAlign.center,
              ),
            ),

          SizedBox(height: 12.h),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _isRecognizing ? null : _clear,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.grey300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.button),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                  child: Text(
                    'negotiation.handwriting_clear'.tr(),
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed:
                      (_isRecognizing || _allStrokes.isEmpty) ? null : _recognize,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.textOnPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.button),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                  child: _isRecognizing
                      ? SizedBox(
                          width: 18.sp,
                          height: 18.sp,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.textOnPrimary,
                          ),
                        )
                      : Text(
                          'negotiation.handwriting_recognize'.tr(),
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCanvas() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        height: 220.h,
        decoration: BoxDecoration(
          color: AppColors.grey50,
          border: Border.all(color: AppColors.grey200),
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: GestureDetector(
          onPanStart: (d) {
            final t = DateTime.now().millisecondsSinceEpoch;
            setState(() {
              _currentStroke.clear();
              _currentStroke.add(mlkit.StrokePoint(
                  x: d.localPosition.dx, y: d.localPosition.dy, t: t));
              _errorMessage = null;
            });
          },
          onPanUpdate: (d) {
            final t = DateTime.now().millisecondsSinceEpoch;
            setState(() {
              _currentStroke.add(mlkit.StrokePoint(
                  x: d.localPosition.dx, y: d.localPosition.dy, t: t));
            });
          },
          onPanEnd: (_) {
            if (_currentStroke.isNotEmpty) {
              setState(() {
                _allStrokes.add(List.from(_currentStroke));
                _currentStroke.clear();
              });
            }
          },
          child: CustomPaint(
            painter: _InkPainter(
              strokes: _allStrokes,
              currentStroke: _currentStroke,
            ),
            size: Size.infinite,
          ),
        ),
      ),
    );
  }
}

class _InkPainter extends CustomPainter {
  const _InkPainter({required this.strokes, required this.currentStroke});

  final List<List<mlkit.StrokePoint>> strokes;
  final List<mlkit.StrokePoint> currentStroke;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.textPrimary
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    void drawStroke(List<mlkit.StrokePoint> points) {
      if (points.length < 2) return;
      final path = Path()
        ..moveTo(points.first.x.toDouble(), points.first.y.toDouble());
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].x.toDouble(), points[i].y.toDouble());
      }
      canvas.drawPath(path, paint);
    }

    for (final stroke in strokes) {
      drawStroke(stroke);
    }
    drawStroke(currentStroke);
  }

  @override
  bool shouldRepaint(_InkPainter old) => true;
}
