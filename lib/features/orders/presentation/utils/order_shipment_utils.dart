/// Backend placeholder vessel name before payment — not a real shipment label.
bool isPendingPaymentVesselPlaceholder(String? vesselName) {
  if (vesselName == null || vesselName.trim().isEmpty) return false;
  final normalized = vesselName.trim().toLowerCase();
  return normalized == 'menunggu pembayaran' ||
      normalized == 'awaiting payment';
}
