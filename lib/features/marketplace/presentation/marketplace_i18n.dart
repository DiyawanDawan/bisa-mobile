import 'package:easy_localization/easy_localization.dart';

/// Locale-independent sentinel for "all categories" in filter state.
const kMarketplaceFilterAllCategory = '__ALL__';

String marketplaceBiomassaTypeLabel(String value) {
  switch (value) {
    case 'BIOCHAR':
      return 'marketplace.biomassa_biochar'.tr();
    case 'SEKAM_PADI':
      return 'marketplace.biomassa_sekam_padi'.tr();
    case 'TONGKOL_JAGUNG':
      return 'marketplace.biomassa_tongkol_jagung'.tr();
    case 'TEMPURUNG_KELAPA':
      return 'marketplace.biomassa_tempurung_kelapa'.tr();
    case 'WOOD_CHIP':
      return 'marketplace.biomassa_wood_chip'.tr();
    case 'OTHER':
      return 'marketplace.biomassa_other'.tr();
    default:
      return value.replaceAll('_', ' ');
  }
}
