import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:mobile_bisa/features/invoice/data/services/invoice_pdf_service.dart';
import 'package:mobile_bisa/features/invoice/domain/entities/invoice_pdf_data.dart';
import 'package:mobile_bisa/features/invoice/domain/entities/invoice_preview_entity.dart';
import 'package:mobile_bisa/features/negotiation/domain/repositories/negotiation_repository.dart';
import 'package:mobile_bisa/features/orders/domain/entities/order_entity.dart';
import 'package:mobile_bisa/injection_container.dart';

class InvoiceExportHelper {
  static Future<void> exportPreview(
    BuildContext context,
    InvoicePreviewEntity preview, {
    Map<String, dynamic>? sellerShippingSnapshot,
    String? sellerOriginLabel,
    Map<String, dynamic>? shippingSelection,
  }) async {
    final supplierName = _currentUserName(context) ?? 'Supplier BISA';
    await _runExport(
      context,
      InvoicePdfData.fromPreview(
        preview,
        supplierName: supplierName,
        sellerShippingSnapshot: sellerShippingSnapshot,
        sellerOriginLabel: sellerOriginLabel,
        shippingSelection: shippingSelection,
      ),
    );
  }

  static Future<void> exportOrder(BuildContext context, OrderEntity order) async {
    await _runExport(context, InvoicePdfData.fromOrder(order));
  }

  static Future<void> exportPdfData(
    BuildContext context,
    InvoicePdfData data,
  ) async {
    await _runExport(context, data);
  }

  static Future<bool> sendPreviewToChat(
    BuildContext context,
    String negotiationId,
    InvoicePreviewEntity preview,
  ) async {
    final supplierName = _currentUserName(context) ?? 'Supplier BISA';
    final data = InvoicePdfData.fromPreview(
      preview,
      supplierName: supplierName,
    );
    return _sendPdfToChat(
      context,
      negotiationId,
      data,
      message: '📎 Tagihan PDF — ${data.invoiceNumber}',
    );
  }

  static Future<bool> sendOrderToChat(
    BuildContext context,
    String negotiationId,
    OrderEntity order,
  ) async {
    final data = InvoicePdfData.fromOrder(order);
    return _sendPdfToChat(
      context,
      negotiationId,
      data,
      message: '📎 Tagihan PDF — ${order.orderNumber}',
    );
  }

  static String? _currentUserName(BuildContext context) {
    return context.read<AuthCubit>().state.maybeWhen(
          authenticated: (user) => user.name,
          orElse: () => null,
        );
  }

  static Future<bool> _sendPdfToChat(
    BuildContext context,
    String negotiationId,
    InvoicePdfData data, {
    required String message,
  }) async {
    if (!context.mounted) return false;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );

    try {
      final file = await InvoicePdfExporter.generateTempFile(data);
      final result = await sl<NegotiationRepository>().sendChatMessage(
        negotiationId,
        message,
        localFilePath: file.path,
      );

      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      return result.fold(
        (failure) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(failure.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
          return false;
        },
        (_) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('PDF tagihan terkirim ke chat negosiasi'),
                backgroundColor: AppColors.secondary,
              ),
            );
          }
          return true;
        },
      );
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal kirim PDF: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
      return false;
    }
  }

  static Future<void> _runExport(BuildContext context, InvoicePdfData data) async {
    if (!context.mounted) return;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );

    try {
      await InvoicePdfExporter.share(data);
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('PDF tagihan siap dibagikan'),
            backgroundColor: AppColors.secondary,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal export PDF: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}
