import '../bloc/create_invoice_cubit.dart';

/// Hasil cek kelengkapan data sebelum terbitkan tagihan.
class InvoiceIssueReadiness {
  const InvoiceIssueReadiness({
    required this.canIssue,
    required this.blockers,
  });

  final bool canIssue;
  final List<String> blockers;

  String get summaryMessage =>
      blockers.isEmpty ? '' : blockers.first;
}

class InvoiceIssueReadinessEvaluator {
  static InvoiceIssueReadiness evaluate(CreateInvoiceState state) {
    final blockers = <String>[];
    final draft = state.draft;
    final preview = state.preview;

    if (preview == null || draft == null) {
      blockers.add('Data tagihan belum dimuat');
      return InvoiceIssueReadiness(canIssue: false, blockers: blockers);
    }

    final draftError = draft.validate();
    if (draftError != null) blockers.add(draftError);

    if (!CreateInvoiceCubit.isDestinationReady(draft)) {
      blockers.add(
        'Alamat tujuan belum lengkap (min. 10 karakter + kab/kota atau provinsi)',
      );
    }

    final sellerSnap = state.sellerShippingSnapshot ?? preview.sellerShippingSnapshot;
    final hasOrigin = state.sellerOriginId != null ||
        preview.sellerOriginId != null ||
        (sellerSnap?['regency']?.toString().trim().isNotEmpty ?? false) ||
        (sellerSnap?['province']?.toString().trim().isNotEmpty ?? false);
    if (!hasOrigin) {
      blockers.add(
        'Asal pengiriman toko belum lengkap (profil bisnis / menu Pengiriman)',
      );
    }

    final selection = state.shippingSelection;
    if (selection == null) {
      blockers.add('Ongkir belum dipilih — tap "Hitung & Pilih Ongkir"');
    } else {
      final courier = selection['courierCode']?.toString().trim() ?? '';
      if (courier.isEmpty) {
        blockers.add('Kurir pengiriman belum dipilih');
      }
      final cost = double.tryParse(selection['cost']?.toString() ?? '') ?? 0;
      if (cost <= 0) {
        blockers.add('Biaya ongkir belum valid');
      }
      final originId = int.tryParse(selection['originId']?.toString() ?? '');
      final destId = int.tryParse(selection['destinationId']?.toString() ?? '');
      if (originId == null || destId == null) {
        blockers.add('Data rute ongkir tidak lengkap — hitung ulang ongkir');
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
      blockers.add('Tagihan terkunci setelah pembayaran diproses');
    }
    blockers.addAll(shippingBlockers);
    return InvoiceIssueReadiness(
      canIssue: blockers.isEmpty,
      blockers: blockers,
    );
  }
}
