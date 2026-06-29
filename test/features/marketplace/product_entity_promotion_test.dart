import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_bisa/features/marketplace/domain/entities/product_entity.dart';

ProductEntity _product({
  bool isPromoted = false,
  DateTime? promotedUntil,
}) {
  return ProductEntity(
    id: 'p1',
    name: 'Biochar A',
    description: 'Test',
    pricePerUnit: 50_000,
    stock: 100,
    minOrder: 1,
    unit: 'ton',
    biomassaType: 'BIOCHAR',
    province: 'Jawa Barat',
    isCertified: true,
    isIotMonitored: false,
    isEscrowProtected: true,
    averageRating: 4.5,
    totalReviews: 10,
    status: 'ACTIVE',
    createdAt: DateTime(2026, 6, 1),
    seller: const ProductSellerEntity(
      id: 's1',
      name: 'Supplier',
      companyName: 'Toko',
      isVerified: true,
    ),
    isPromoted: isPromoted,
    promotedUntil: promotedUntil,
  );
}

void main() {
  group('ProductEntity.isPromotionActive (FB-16)', () {
    test('false when not promoted', () {
      expect(_product().isPromotionActive, isFalse);
    });

    test('false when promotedUntil is in the past', () {
      final p = _product(
        isPromoted: true,
        promotedUntil: DateTime.now().subtract(const Duration(days: 1)),
      );
      expect(p.isPromotionActive, isFalse);
    });

    test('true when promoted and promotedUntil is in the future', () {
      final p = _product(
        isPromoted: true,
        promotedUntil: DateTime.now().add(const Duration(days: 7)),
      );
      expect(p.isPromotionActive, isTrue);
    });
  });
}
