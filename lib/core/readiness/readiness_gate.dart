import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../injection_container.dart';
import '../network/api_client.dart';
import 'readiness_gate_sheet.dart';
import 'readiness_models.dart';
import 'readiness_service.dart';

class ReadinessGate {
  ReadinessGate._();

  static ReadinessService get _service =>
      ReadinessService(sl<ApiClient>().dio);

  static Future<UserReadiness?> _fetch() async {
    try {
      return await _service.fetchReadiness();
    } catch (_) {
      return null;
    }
  }

  static Future<bool> ensureStoreReady(BuildContext context) async {
    final readiness = await _fetch();
    final store = readiness?.store;
    if (store == null || store.ready) return true;
    if (!context.mounted) return false;
    await ReadinessGateSheet.showStore(context, store);
    return false;
  }

  static Future<bool> ensureBuyerReady(BuildContext context) async {
    final readiness = await _fetch();
    final buyer = readiness?.buyer;
    if (buyer == null || buyer.ready) return true;
    if (!context.mounted) return false;
    await ReadinessGateSheet.showBuyer(context, buyer);
    return false;
  }

  static Future<void> pushAddProduct(BuildContext context) async {
    if (!await ensureStoreReady(context)) return;
    if (context.mounted) context.push('/add-product');
  }

  static Future<void> handleReadinessApiError(
    BuildContext context, {
    required String? code,
    required List<String> missing,
    required String fallbackMessage,
  }) async {
    if (!context.mounted) return;

    if (code == 'STORE_NOT_READY') {
      await ReadinessGateSheet.showStore(
        context,
        RoleReadiness(
          ready: false,
          missing: missing,
          messages: missing.map(readinessLabelForKey).toList(),
        ),
      );
      return;
    }

    if (code == 'BUYER_NOT_READY') {
      await ReadinessGateSheet.showBuyer(
        context,
        RoleReadiness(
          ready: false,
          missing: missing,
          messages: missing.map(readinessLabelForKey).toList(),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(fallbackMessage)),
    );
  }
}
