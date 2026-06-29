import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mobile_bisa/core/utils/app_feedback.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:mobile_bisa/features/invoice/data/services/invoice_pdf_service.dart';
import 'package:mobile_bisa/features/invoice/domain/entities/invoice_pdf_data.dart';
import 'package:mobile_bisa/features/invoice/domain/entities/invoice_pdf_labels.dart';
import 'package:mobile_bisa/features/invoice/domain/entities/invoice_preview_entity.dart';
import 'package:mobile_bisa/features/negotiation/domain/repositories/negotiation_repository.dart';
import 'package:mobile_bisa/features/invoice/presentation/utils/invoice_pdf_i18n.dart';
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
    final labels = InvoicePdfLabels.fromContext(context);
    final supplierName = _currentUserName(context) ?? labels.defaultSupplierName;
    final data = localizeInvoicePdfData(
      InvoicePdfData.fromPreview(
        preview,
        supplierName: supplierName,
        sellerShippingSnapshot: sellerShippingSnapshot,
        sellerOriginLabel: sellerOriginLabel,
        shippingSelection: shippingSelection,
      ),
      isPreview: true,
    );
    await _runExport(context, data, labels: labels);
  }

  static Future<void> exportOrder(BuildContext context, OrderEntity order) async {
    final labels = InvoicePdfLabels.fromContext(context);
    final data = localizeInvoicePdfData(
      InvoicePdfData.fromOrder(order),
      order: order,
    );
    await _runExport(context, data, labels: labels);
  }

  static Future<void> exportPdfData(
    BuildContext context,
    InvoicePdfData data, {
    OrderEntity? order,
  }) async {
    final labels = InvoicePdfLabels.fromContext(context);
    final localized = localizeInvoicePdfData(data, order: order);
    await _runExport(context, localized, labels: labels);
  }

  static Future<bool> sendPreviewToChat(
    BuildContext context,
    String negotiationId,
    InvoicePreviewEntity preview,
  ) async {
    final labels = InvoicePdfLabels.fromContext(context);
    final supplierName = _currentUserName(context) ?? labels.defaultSupplierName;
    final data = localizeInvoicePdfData(
      InvoicePdfData.fromPreview(
        preview,
        supplierName: supplierName,
      ),
      isPreview: true,
    );
    return _sendPdfToChat(
      context,
      negotiationId,
      data,
      labels: labels,
      message: labels.chatAttachment(data.invoiceNumber),
    );
  }

  static Future<bool> sendOrderToChat(
    BuildContext context,
    String negotiationId,
    OrderEntity order,
  ) async {
    final labels = InvoicePdfLabels.fromContext(context);
    final data = localizeInvoicePdfData(
      InvoicePdfData.fromOrder(order),
      order: order,
    );
    return _sendPdfToChat(
      context,
      negotiationId,
      data,
      labels: labels,
      message: labels.chatAttachment(order.orderNumber),
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
    required InvoicePdfLabels labels,
    required String message,
  }) async {
    final intlLocale = InvoicePdfLabels.intlLocaleFor(context.locale);
    if (!context.mounted) return false;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );

    try {
      final file = await InvoicePdfExporter.generateTempFile(
        data,
        labels: labels,
        intlLocale: intlLocale,
      );
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
            showFailureSnackBarFromMessage(context, failure.message);
          }
          return false;
        },
        (_) {
          if (context.mounted) {
            showSuccessSnackBar(context, 'invoice.send_success'.tr());
          }
          return true;
        },
      );
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        showErrorSnackBar(context, 'invoice.send_failed'.tr(namedArgs: {'error': '$e'}));
      }
      return false;
    }
  }

  static Future<void> _runExport(
    BuildContext context,
    InvoicePdfData data, {
    required InvoicePdfLabels labels,
  }) async {
    if (!context.mounted) return;
    final intlLocale = InvoicePdfLabels.intlLocaleFor(context.locale);

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );

    try {
      await InvoicePdfExporter.share(
        data,
        labels: labels,
        intlLocale: intlLocale,
      );
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        showSuccessSnackBar(context, 'invoice.export_ready'.tr());
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        showErrorSnackBar(context, 'invoice.export_failed'.tr(namedArgs: {'error': '$e'}));
      }
    }
  }
}
