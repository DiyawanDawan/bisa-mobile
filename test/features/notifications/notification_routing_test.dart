import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_bisa/features/notifications/domain/entities/notification_entity.dart';
import 'package:mobile_bisa/features/notifications/presentation/utils/notification_ui_utils.dart';

NotificationEntity _notification({
  required String type,
  String? refId,
  String title = '',
  String body = '',
}) {
  return NotificationEntity(
    id: 'notif-1',
    title: title,
    body: body,
    type: type,
    priority: 'HIGH',
    isRead: false,
    refId: refId,
    createdAt: DateTime(2026, 5, 31),
  );
}

void main() {
  group('DISPUTE notification routing', () {
    test('type DISPUTE routes to order detail', () {
      final action = notificationAction(
        _notification(type: 'DISPUTE', refId: 'order-abc'),
      );
      expect(action?.route, '/order/order-abc');
      expect(action?.label, 'Lihat Sengketa');
    });

    test('type ORDER_DISPUTE routes to order detail', () {
      final action = notificationAction(
        _notification(type: 'ORDER_DISPUTE', refId: 'order-xyz'),
      );
      expect(action?.route, '/order/order-xyz');
    });

    test('ORDER_STATUS with sengketa keyword routes to order detail', () {
      final action = notificationAction(
        _notification(
          type: 'ORDER_STATUS',
          refId: 'order-99',
          title: 'Sengketa Pesanan',
          body: 'Pembeli mengajukan sengketa.',
        ),
      );
      expect(action?.route, '/order/order-99');
      expect(action?.label, 'Lihat Sengketa');
    });
  });

  group('dispute keyword detection', () {
    test('detects sengketa in title/body', () {
      expect(
        notificationIsDisputeRelatedFromText('Sengketa Pesanan', ''),
        isTrue,
      );
      expect(
        notificationIsDisputeRelatedFromText('', 'Ada komplain baru'),
        isTrue,
      );
      expect(
        notificationIsDisputeRelatedFromText('Pesanan dikirim', 'Status SHIPPED'),
        isFalse,
      );
    });
  });
}
