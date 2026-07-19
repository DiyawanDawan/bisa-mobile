import 'package:flutter/widgets.dart';
import 'package:mobile_bisa/core/network/api_client.dart';
import 'package:mobile_bisa/features/orders/presentation/widgets/payment_method_picker_sheet.dart';
import 'package:mobile_bisa/injection_container.dart';

/// Satu sumber untuk metode bayar tersimpan + picker sheet.
class PaymentMethodResolver {
  PaymentMethodResolver._();

  /// Preferensi default dari `/users/me/saved-payments`.
  static Future<PaymentMethodChoice?> loadSaved() async {
    try {
      final res = await sl<ApiClient>().dio.get('/users/me/saved-payments');
      final list = res.data['data'] as List? ?? [];
      if (list.isEmpty) return null;
      final def = list.cast<Map>().firstWhere(
            (e) => e['isDefault'] == true,
            orElse: () => list.first,
          );
      final code = '${def['channelCode']}'.trim();
      if (code.isEmpty) return null;
      final name = '${def['channelName']}'.trim();
      return PaymentMethodChoice(
        code: code,
        name: name.isEmpty ? code : name,
      );
    } catch (_) {
      return null;
    }
  }

  /// Pakai saved default bila ada; jika tidak, buka [PaymentMethodPickerSheet].
  static Future<PaymentMethodChoice?> resolve(
    BuildContext context, {
    required num amount,
    String? initialCode,
    bool preferSaved = true,
  }) async {
    if (preferSaved) {
      final saved = await loadSaved();
      if (saved != null) return saved;
    }
    if (!context.mounted) return null;
    return PaymentMethodPickerSheet.show(
      context,
      amount: amount,
      initialCode: initialCode,
    );
  }
}
