import '../../../../core/i18n/failure_messages.dart';
import '../bloc/create_invoice_cubit.dart';

/// Hasil cek kelengkapan data sebelum terbitkan tagihan.
class InvoiceIssueReadiness {
  const InvoiceIssueReadiness({
    required this.canIssue,
    required this.blockers,
  });

  final bool canIssue;
  final List<String> blockers;

  String get summaryMessage => blockers.isEmpty
      ? ''
      : localizeFailureMessage(blockers.first);
}

class InvoiceIssueReadinessEvaluator {
  static InvoiceIssueReadiness evaluate(CreateInvoiceState state) {
    final blockers = <String>[];
    final draft = state.draft;
    final preview = state.preview;

    if (preview == null || draft == null) {
      blockers.add('invoice.readiness_not_loaded');
      return InvoiceIssueReadiness(canIssue: false, blockers: blockers);
    }

    final draftError = draft.validate();
    if (draftError != null) blockers.add(draftError);

    if (!CreateInvoiceCubit.isDestinationReady(draft)) {
      blockers.add('invoice.readiness_dest_incomplete');
    }

    final sellerSnap = state.sellerShippingSnapshot ?? preview.sellerShippingSnapshot;
    final hasOrigin = state.sellerOriginId != null ||
        preview.sellerOriginId != null ||
        (sellerSnap?['regency']?.toString().trim().isNotEmpty ?? false) ||
        (sellerSnap?['province']?.toString().trim().isNotEmpty ?? false);
    if (!hasOrigin) {
      blockers.add('invoice.readiness_origin_incomplete');
    }

    final selection = state.shippingSelection;
    if (selection == null) {
      blockers.add('invoice.readiness_shipping_not_selected');
    } else {
      final courier = selection['courierCode']?.toString().trim() ?? '';
      if (courier.isEmpty) {
        blockers.add('invoice.readiness_courier_not_selected');
      }
      final cost = double.tryParse(selection['cost']?.toString() ?? '') ?? 0;
      if (cost <= 0) {
        blockers.add('invoice.readiness_shipping_cost_invalid');
      }
      final originId = int.tryParse(selection['originId']?.toString() ?? '');
      final destId = int.tryParse(selection['destinationId']?.toString() ?? '');
      if (originId == null || destId == null) {
        blockers.add('invoice.readiness_route_incomplete');
      }
    }

    return InvoiceIssueReadiness(
      canIssue: blockers.isEmpty,
      blockers: blockers,
    );
  }

  /// Edit tagihan pending — cukup validasi alamat & kontak.
  static InvoiceIssueReadiness evaluateEditShipping({
    required bool canEdit,
    required List<String> shippingBlockers,
  }) {
    final blockers = <String>[];
    if (!canEdit) {
      blockers.add('invoice.readiness_locked_after_payment');
    }
    blockers.addAll(shippingBlockers);
    return InvoiceIssueReadiness(
      canIssue: blockers.isEmpty,
      blockers: blockers,
    );
  }
}
