import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_bisa/core/errors/failures.dart';
import 'package:mobile_bisa/core/network/auth_session_bridge.dart';
import 'package:mobile_bisa/core/utils/payment_status_utils.dart';
import 'package:mobile_bisa/features/auth/domain/entities/user_entity.dart';
import 'package:mobile_bisa/features/auth/domain/repositories/auth_repository.dart';
import 'package:mobile_bisa/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:mobile_bisa/features/orders/data/models/order_model.dart';
import 'package:mobile_bisa/features/orders/domain/entities/order_entity.dart';
import 'package:mobile_bisa/features/orders/domain/repositories/order_repository.dart';
import 'package:mobile_bisa/features/orders/presentation/utils/checkout_navigation.dart';
import 'package:mobile_bisa/features/profile/domain/entities/address_entity.dart';

// --- Fakes ---

class _FakeAuthRepository implements AuthRepository {
  String resetToken;

  _FakeAuthRepository({this.resetToken = 'reset-token-abc'});

  @override
  Future<Either<Failure, String>> verifyResetCode(
    String email,
    String code,
  ) async =>
      Right(resetToken);

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

class _FakeOrderRepository implements OrderRepository {
  _FakeOrderRepository(this.responses);

  final List<Either<Failure, OrderEntity>> responses;
  int callCount = 0;

  @override
  Future<Either<Failure, OrderEntity>> getOrderDetail(String id) async {
    final idx = callCount < responses.length ? callCount : responses.length - 1;
    callCount++;
    return responses[idx];
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

OrderEntity _order({
  required String status,
  String? paymentStatus,
}) {
  return OrderEntity(
    id: 'ord-1',
    orderNumber: 'ORD-001',
    status: status,
    totalAmount: 100000,
    totalQuantity: 1,
    subtotal: 100000,
    platformFee: 0,
    vatAmount: 0,
    createdAt: DateTime(2026, 1, 1),
    items: const [],
    buyer: const OrderParticipantEntity(id: 'b1', name: 'Buyer'),
    seller: const OrderParticipantEntity(id: 's1', name: 'Seller'),
    transaction: paymentStatus == null
        ? null
        : OrderTransactionEntity(
            status: 'PENDING',
            paymentStatus: paymentStatus,
          ),
  );
}

Map<String, dynamic> _minimalOrderJson({
  String createdAt = 'not-a-valid-date',
  String? paidAt,
}) {
  return {
    'id': 'ord-1',
    'orderNumber': 'ORD-001',
    'status': 'PENDING',
    'totalAmount': 100000,
    'totalQuantity': 1,
    'subtotal': 100000,
    'platformFee': 0,
    'logisticsFee': 0,
    'vatAmount': 0,
    'createdAt': createdAt,
    'items': [
      {
        'id': 'item-1',
        'productId': 'prod-1',
        'quantity': 1,
        'pricePerUnit': 100000,
        'subtotal': 100000,
        'product': {'name': 'Test Product', 'unit': 'kg'},
      },
    ],
    'buyer': {'fullName': 'Buyer'},
    'seller': {'fullName': 'Seller'},
    if (paidAt != null)
      'transaction': {
        'status': 'PENDING',
        'paidAt': paidAt,
      },
  };
}

void main() {
  group('BUG-001 reset password OTP flow', () {
    test('verifyResetCode emits resetTokenReceived with token from API', () async {
      final cubit = AuthCubit(_FakeAuthRepository(resetToken: 'tok-xyz'));
      await cubit.verifyResetCode('a@b.com', '123456');
      expect(
        cubit.state,
        const AuthState.resetTokenReceived('tok-xyz'),
      );
      await cubit.close();
    });
  });

  group('BUG-002 order date parsing', () {
    test('toEntity does not throw on invalid createdAt', () {
      final model = OrderModel.fromJson(_minimalOrderJson());
      expect(() => model.toEntity(), returnsNormally);
    });

    test('toEntity handles invalid paidAt without throw', () {
      final model = OrderModel.fromJson(
        _minimalOrderJson(paidAt: 'bad-date'),
      );
      final entity = model.toEntity();
      expect(entity.transaction?.paidAt, isNull);
    });
  });

  group('BUG-003 session expiry', () {
    test('AuthSessionBridge notifies listener', () {
      var notified = false;
      final bridge = AuthSessionBridge();
      bridge.onSessionExpired = () => notified = true;
      bridge.notifySessionExpired();
      expect(notified, isTrue);
    });

    test('AuthCubit.sessionExpired emits unauthenticated', () async {
      final cubit = AuthCubit(_FakeAuthRepository());
      cubit.sessionExpired();
      expect(cubit.state, const AuthState.unauthenticated());
      await cubit.close();
    });
  });

  group('BUG-004 checkout payment init failure', () {
    test('paymentInitFailureRoute goes to order detail not checkout-result', () {
      final route = paymentInitFailureRoute('ord-99');
      expect(route, '/order/ord-99?autoPay=1');
      expect(route, isNot(contains('checkout-result')));
    });

    test('empty order id returns null route', () {
      expect(paymentInitFailureRoute(null), isNull);
      expect(paymentInitFailureRoute(''), isNull);
    });
  });

  group('BUG-005 payment WebView server confirmation', () {
    test('parsePaymentWebViewExit maps callback without treating as paid', () {
      expect(
        parsePaymentWebViewExit(PaymentWebViewExit.callbackDetected),
        PaymentWebViewExit.callbackDetected,
      );
      expect(parsePaymentWebViewExit(true), PaymentWebViewExit.callbackDetected);
      expect(parsePaymentWebViewExit(false), PaymentWebViewExit.failed);
    });

    test('isOrderPaid uses order and transaction status', () {
      expect(isOrderPaid(_order(status: 'PROCESSING')), isTrue);
      expect(
        isOrderPaid(_order(status: 'PENDING', paymentStatus: 'SUCCESS')),
        isTrue,
      );
      expect(isOrderPaid(_order(status: 'PENDING')), isFalse);
    });

    test('pollOrderPaymentStatus confirms via API not URL alone', () async {
      final repo = _FakeOrderRepository([
        Right(_order(status: 'PENDING')),
        Right(_order(status: 'PROCESSING')),
      ]);
      final paid = await pollOrderPaymentStatus(
        repo,
        'ord-1',
        maxAttempts: 3,
        interval: Duration.zero,
      );
      expect(paid, isTrue);
      expect(repo.callCount, 2);
    });
  });
}
