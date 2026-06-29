import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_layout.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/readiness/readiness_gate.dart';
import '../../../../core/services/location_service.dart';
import '../../../../core/utils/app_feedback.dart';
import '../../../../core/utils/money_format.dart';
import '../../../../core/utils/safe_area_utils.dart' show clearBisaSnackBars;
import '../../../../core/utils/safe_navigator.dart';
import '../../../../core/network/api_client.dart';
import '../../../../injection_container.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../profile/domain/entities/address_entity.dart';
import '../../../../shared/widgets/bisa_avatar.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../../../../shared/widgets/bisa_network_image.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/osm_location_picker_page.dart';
import '../../../marketplace/domain/entities/product_entity.dart';
import '../../../marketplace/presentation/bloc/marketplace_cubit.dart';
import '../../../marketplace/presentation/widgets/product_card.dart';
import '../../../../shared/widgets/product_card_skeleton.dart';
import '../../../../shared/widgets/shimmer_loading.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../orders/data/shipping_destination_cache.dart';
import '../../../orders/presentation/bloc/order_cubit.dart';
import '../../../orders/presentation/utils/checkout_navigation.dart';
import '../../../orders/presentation/widgets/payment_method_picker_sheet.dart';
import '../../data/datasources/commerce_remote_data_source.dart';
import '../../domain/repositories/commerce_repository.dart';
import '../widgets/mode_product_catalog.dart';
import '../bloc/commerce_cubit.dart';

class CartPage extends StatefulWidget {
  /// `true` pada rute `/checkout-result`: alamat, ongkir, breakdown, bayar.
  final bool checkoutMode;

  /// ID item keranjang yang dipilih di halaman keranjang.
  final Set<String>? initialSelectedIds;

  const CartPage({
    super.key,
    this.checkoutMode = false,
    this.initialSelectedIds,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  /// Set of cart item IDs yang sedang menampilkan snackbar stok,
  /// supaya tidak spam saat user tap `+` berulang.
  final Set<String> _stockToastShown = {};

  /// Cart item IDs yang dicentang user untuk di-checkout.
  /// Default: semua item ter-select setelah load.
  final Set<String> _selectedItemIds = {};

  /// True kalau pertama kali cart di-load → auto-select semua item valid (stok > 0).
  bool _initialSelectionDone = false;

  /// True saat tombol "Checkout" diklik dan request sedang berjalan.
  bool _isCheckingOut = false;
  final Map<String, Map<String, dynamic>> _shippingSelectionBySeller = {};
  final Set<String> _shippingLoadingSellerIds = {};
  final Map<String, String> _shippingErrorBySeller = {};
  final Map<String, String> _destinationQueryBySeller = {};
  final Map<String, String> _courierBySeller = {};
  /// Query untuk pencarian destinasi RajaOngkir (biasanya kota + provinsi).
  String? _shippingAddressQuery;
  /// Alamat lengkap untuk API checkout/preview (min. 10 karakter).
  String? _shippingFullAddress;
  String? _shippingAddressLabel;
  AddressEntity? _selectedProfileAddress;
  bool _usingPrimaryProfile = false;
  Map<String, dynamic>? _checkoutPreview;
  bool _checkoutPreviewLoading = false;
  String? _checkoutPreviewError;
  String? _lastCheckoutPreviewKey;
  int _checkoutPreviewRequestId = 0;
  Timer? _checkoutPreviewDebounce;
  String? _lastCommerceErrorSnack;

  LocationFix? _shippingFix;
  bool _detectingLocation = false;
  String? _locationError;
  bool _shippingQuotaExceeded = false;
  String? _shippingQuotaMessage;
  Map<String, dynamic>? _cachedBuyerDestination;
  String? _cachedBuyerDestinationQuery;

  PaymentMethodChoice? _selectedPayment;
  final _voucherCtrl = TextEditingController();
  String? _appliedVoucherCode;
  String? _voucherError;
  bool _voucherApplying = false;
  PaymentMethodChoice? _savedPaymentPref;

  bool get _isCheckoutFlow => widget.checkoutMode;

  @override
  void initState() {
    super.initState();
    context.read<CommerceCubit>().loadCart();
    if (_isCheckoutFlow) {
      _initialSelectionDone = true;
      if (widget.initialSelectedIds != null) {
        _selectedItemIds.addAll(widget.initialSelectedIds!);
      }
      _loadPrimaryProfileAddress();
      _loadSavedPaymentPreference();
    }
  }

  @override
  void dispose() {
    _checkoutPreviewDebounce?.cancel();
    _voucherCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadSavedPaymentPreference() async {
    try {
      final res = await sl<ApiClient>().dio.get('/users/me/saved-payments');
      final list = res.data['data'] as List? ?? [];
      if (list.isEmpty || !mounted) return;
      final def = list.cast<Map>().firstWhere(
            (e) => e['isDefault'] == true,
            orElse: () => list.first,
          );
      setState(() {
        _savedPaymentPref = PaymentMethodChoice(
          code: '${def['channelCode']}',
          name: '${def['channelName']}',
        );
        _selectedPayment ??= _savedPaymentPref;
      });
    } catch (_) {}
  }

  Future<void> _applyVoucher(CartSummary cart) async {
    final code = _voucherCtrl.text.trim();
    if (code.isEmpty) {
      setState(() {
        _appliedVoucherCode = null;
        _voucherError = null;
        _lastCheckoutPreviewKey = null;
      });
      _scheduleCheckoutPreviewRefresh(cart);
      return;
    }
    final selected = cart.items.where((it) => _selectedItemIds.contains(it.id));
    final subtotal = selected.fold<double>(
      0,
      (sum, it) => sum + (it.product.toEntity().pricePerUnit * it.quantity),
    );
    final sellerIds = selected
        .map((it) => it.product.toEntity().seller.id)
        .toSet()
        .toList();
    setState(() {
      _voucherApplying = true;
      _voucherError = null;
    });
    final result = await context.read<OrderCubit>().validateVoucher(
          code: code,
          subtotal: subtotal,
          sellerIds: sellerIds,
        );
    if (!mounted) return;
    if (result == null) {
      setState(() {
        _voucherApplying = false;
        _voucherError = 'cart.voucher_invalid'.tr();
        _appliedVoucherCode = null;
        _lastCheckoutPreviewKey = null;
      });
      return;
    }
    setState(() {
      _voucherApplying = false;
      _appliedVoucherCode = code.toUpperCase();
      _voucherError = null;
      _lastCheckoutPreviewKey = null;
    });
    _scheduleCheckoutPreviewRefresh(cart);
  }

  String _fullAddressLineFromEntity(AddressEntity a) {
    final line = a.address.trim();
    if (line.length >= 10) return line;
    final parts = [
      a.address,
      a.village,
      a.district,
      a.city,
      a.province,
      a.postalCode,
    ].where((e) => e.trim().isNotEmpty);
    final joined = parts.join(', ');
    return joined.length >= 10 ? joined : line;
  }

  String _normalizeRajaOngkirSearch(String raw) {
    var s = raw.trim().replaceAll(RegExp(r'\s+'), ' ');
    s = s.replaceAll(
      RegExp(r'^(kabupaten|kab\.?|kota)\s+', caseSensitive: false),
      '',
    );
    return s.trim();
  }

  /// Kata kunci yang masuk akal untuk API destinasi RajaOngkir (bukan nama penerima).
  bool _looksLikeLocationQuery(String value) {
    final s = _normalizeRajaOngkirSearch(value);
    if (s.length < 3) return false;
    final lower = s.toLowerCase();
    const blocked = {
      'indonesia',
      'nusa tenggara barat',
      'nusa tenggara',
      'ntb',
      'ntt',
      'banten',
      'jakarta',
      'bali',
      'jawa',
    };
    if (blocked.contains(lower)) return false;

    const tokens = [
      'kab',
      'kota',
      'kec',
      'kel',
      'desa',
      'prov',
      'jalan',
      'jl.',
      'jl ',
    ];
    if (tokens.any(lower.contains)) return true;
    if (s.contains(',')) {
      final parts = s.split(',').map((p) => p.trim()).where((p) => p.isNotEmpty);
      return parts.length >= 2 && parts.every((p) => p.length >= 3);
    }
    if (RegExp(r'\d').hasMatch(s)) return true;
    return false;
  }

  String? _geographicQueryFromEntity(AddressEntity a) {
    if (a.city.trim().isNotEmpty && a.province.trim().isNotEmpty) {
      return _normalizeRajaOngkirSearch('${a.city.trim()}, ${a.province.trim()}');
    }
    final parts = <String>[
      if (a.district.trim().isNotEmpty) a.district.trim(),
      if (a.city.trim().isNotEmpty) a.city.trim(),
      if (a.province.trim().isNotEmpty) a.province.trim(),
      if (a.village.trim().isNotEmpty) a.village.trim(),
    ];
    if (parts.length >= 2) {
      return '${parts[parts.length - 2]}, ${parts.last}';
    }
    if (parts.isNotEmpty && _looksLikeLocationQuery(parts.join(' '))) {
      return parts.join(', ');
    }
    return null;
  }

  String? _rajaOngkirQueryFromEntity(AddressEntity a) {
    return _geographicQueryFromEntity(a);
  }

  String _displayLineFromEntity(AddressEntity a) {
    final parts = [
      a.village,
      a.district,
      a.city,
      a.province,
      a.postalCode,
    ].where((e) => e.trim().isNotEmpty);
    if (parts.isNotEmpty) return parts.join(', ');
    return a.address;
  }

  Map<String, dynamic> _shippingSnapshotFromEntity(AddressEntity a) {
    return {
      if (a.phoneNumber.trim().isNotEmpty) 'phone': a.phoneNumber.trim(),
      'address': _fullAddressLineFromEntity(a),
      if (a.postalCode.trim().isNotEmpty) 'zipCode': a.postalCode.trim(),
      if (a.province.trim().isNotEmpty) 'province': a.province.trim(),
      if (a.city.trim().isNotEmpty) 'regency': a.city.trim(),
    };
  }

  ({String? shippingAddress, Map<String, dynamic>? shippingSnapshot})
      _checkoutShippingPayload() {
    final full = (_shippingFullAddress?.trim().isNotEmpty ?? false)
        ? _shippingFullAddress!.trim()
        : (_shippingAddressQuery?.trim().isNotEmpty ?? false) &&
                (_shippingAddressQuery!.trim().length >= 10)
            ? _shippingAddressQuery!.trim()
            : (_shippingFix?.address?.trim().isNotEmpty ?? false)
                ? _shippingFix!.address!.trim()
                : null;
    final snapshot = _selectedProfileAddress != null
        ? _shippingSnapshotFromEntity(_selectedProfileAddress!)
        : null;
    return (shippingAddress: full, shippingSnapshot: snapshot);
  }

  void _clearShippingSelections() {
    _shippingSelectionBySeller.clear();
    _destinationQueryBySeller.clear();
    _checkoutPreview = null;
    _checkoutPreviewError = null;
    _cachedBuyerDestination = null;
    _cachedBuyerDestinationQuery = null;
  }

  void _applyProfileAddress(AddressEntity a, {bool silent = false}) {
    final label = a.name.trim().isNotEmpty
        ? a.name.trim()
        : 'cart.address_fallback'.tr();
    final displayLabel = a.isPrimary
        ? 'cart.address_primary_suffix'.tr(namedArgs: {'label': label})
        : label;
    setState(() {
      _selectedProfileAddress = a;
      _usingPrimaryProfile = a.isPrimary;
      _shippingAddressLabel = displayLabel;
      _shippingAddressQuery = _rajaOngkirQueryFromEntity(a);
      _shippingFullAddress = _fullAddressLineFromEntity(a);
      if (_shippingAddressQuery == null || _shippingAddressQuery!.isEmpty) {
        _locationError = 'cart.address_incomplete_region'.tr();
      }
      _shippingFix = null;
      _locationError = null;
      _clearShippingSelections();
    });
    if (!silent && mounted) {
      showSuccessSnackBar(
        context,
        a.isPrimary
            ? 'cart.snack_primary_used'.tr()
            : 'cart.snack_profile_selected'.tr(),
        duration: const Duration(seconds: 2),
      );
    }
  }

  Future<void> _loadPrimaryProfileAddress() async {
    final result = await sl<AuthRepository>().getAddresses();
    if (!mounted) return;
    final addresses = result.fold((_) => <AddressEntity>[], (list) => list);
    if (addresses.isEmpty) return;
    final primary = addresses.firstWhere(
      (a) => a.isPrimary,
      orElse: () => addresses.first,
    );
    _applyProfileAddress(primary, silent: true);
  }

  /// Sync selection state setiap kali cart berubah (item ditambah/dihapus dst).
  /// First load → select semua item yang stoknya > 0.
  /// Subsequent loads → buang ID yang sudah tidak ada di cart.
  void _syncSelection(CartSummary cart) {
    final validIds = cart.items.map((e) => e.id).toSet();
    if (!_initialSelectionDone) {
      _selectedItemIds
        ..clear()
        ..addAll(
          cart.items
              .where((it) => it.product.toEntity().stock > 0)
              .map((it) => it.id),
        );
      _initialSelectionDone = true;
    } else {
      _selectedItemIds.removeWhere((id) => !validIds.contains(id));
    }
  }

  void _toggleItemSelection(String cartItemId, bool? value) {
    setState(() {
      if (value == true) {
        _selectedItemIds.add(cartItemId);
      } else {
        _selectedItemIds.remove(cartItemId);
      }
    });
    if (_isCheckoutFlow) {
      final cart = context.read<CommerceCubit>().state.cart;
      if (cart != null) _refreshCheckoutPreview(cart);
    }
  }

  void _toggleGroupSelection(List<CartItemModel> items, bool select) {
    setState(() {
      for (final it in items) {
        if (it.product.toEntity().stock <= 0) continue;
        if (select) {
          _selectedItemIds.add(it.id);
        } else {
          _selectedItemIds.remove(it.id);
        }
      }
    });
    if (_isCheckoutFlow) {
      final cart = context.read<CommerceCubit>().state.cart;
      if (cart != null) _refreshCheckoutPreview(cart);
    }
  }

  Future<void> _onCheckout(BuildContext context, CartSummary cart) async {
    final selectedItems = cart.items
        .where((it) => _selectedItemIds.contains(it.id))
        .toList();

    if (selectedItems.isEmpty) {
      showWarningSnackBar(context, 'cart.snack_select_min_one'.tr());
      return;
    }

    // Validate stock satu kali lagi sebelum kirim ke backend.
    final outOfStockSelected = selectedItems.any(
      (it) => it.product.toEntity().stock <= 0,
    );
    if (outOfStockSelected) {
      showErrorSnackBar(context, 'cart.snack_out_of_stock_selection'.tr());
      return;
    }

    if (!await ReadinessGate.ensureBuyerReady(context)) return;
    if (!context.mounted) return;

    setState(() => _isCheckingOut = true);

    final items = selectedItems
        .map((it) => {
              'productId': it.product.toEntity().id,
              'quantity': it.quantity,
            })
        .toList();

    final orderCubit = context.read<OrderCubit>();
    final commerceCubit = context.read<CommerceCubit>();
    final shippingSelections = _buildShippingSelectionsForCheckout(selectedItems);
    if (shippingSelections.length !=
        selectedItems
            .map((it) => it.product.toEntity().seller.id)
            .toSet()
            .length) {
      setState(() => _isCheckingOut = false);
      showWarningSnackBar(context, 'cart.snack_setup_shipping_all'.tr());
      return;
    }

    final shippingPayload = _checkoutShippingPayload();
    if (shippingPayload.shippingAddress == null ||
        shippingPayload.shippingAddress!.length < 10) {
      setState(() => _isCheckingOut = false);
      showWarningSnackBar(context, 'cart.snack_shipping_incomplete'.tr());
      return;
    }

    PaymentMethodChoice? payment = _selectedPayment;
    if (_isCheckoutFlow && payment == null) {
      final previewTotal = _checkoutPreview?['totalAmount'];
      final fallbackTotal = selectedItems.fold<double>(
        0,
        (sum, it) =>
            sum + (it.product.toEntity().pricePerUnit * it.quantity),
      );
      final amount = previewTotal is num
          ? previewTotal
          : (previewTotal != null
              ? num.tryParse(previewTotal.toString()) ?? fallbackTotal
              : fallbackTotal);
      payment = await PaymentMethodPickerSheet.show(
        context,
        amount: amount,
      );
      if (!context.mounted) return;
      if (payment == null) {
        setState(() => _isCheckingOut = false);
        return;
      }
      setState(() => _selectedPayment = payment);
    }

    final result = await orderCubit.createDirectOrder(
      items: items,
      shippingAddress: shippingPayload.shippingAddress,
      shippingSnapshot: shippingPayload.shippingSnapshot,
      shippingSelections: shippingSelections.isEmpty ? null : shippingSelections,
      voucherCode: _appliedVoucherCode,
    );

    if (!context.mounted) return;

    if (!result.isSuccess) {
      setState(() => _isCheckingOut = false);
      final message = result.errorMessage ?? 'cart.order_create_failed';
      if (result.isBuyerReadiness) {
        await ReadinessGate.ensureBuyerReady(context);
      } else {
        showFailureSnackBarFromMessage(context, message);
      }
      return;
    }

    final orders = result.orders;
    if (!context.mounted) return;

    final orderIds = orders
        .map((o) => o['orderId']?.toString())
        .whereType<String>()
        .where((id) => id.isNotEmpty)
        .toList();

    // Checkout + bayar: jangan loadCart / kosongkan UI dulu — overlay tetap sampai pindah halaman.
    if (_isCheckoutFlow && payment != null && orderIds.isNotEmpty) {
      final Map<String, dynamic>? payData;
      if (orderIds.length > 1) {
        payData = await orderCubit.initializeBatchPayment(
          orderIds,
          payment.code,
        );
      } else {
        payData = await orderCubit.initializePayment(
          orderIds.first,
          payment.code,
        );
      }
      if (!context.mounted) return;

      if (payData == null) {
        setState(() => _isCheckingOut = false);
        unawaited(commerceCubit.loadCart());
        if (mounted) {
          setState(() {
            for (final it in selectedItems) {
              _selectedItemIds.remove(it.id);
            }
          });
        }
        showErrorSnackBar(
          context,
          context.read<OrderCubit>().state.maybeWhen(
                error: (msg) => msg,
                orElse: () => 'cart.payment_init_failed'.tr(),
              ),
          duration: const Duration(seconds: 5),
        );
        final failureRoute = paymentInitFailureRoute(orderIds.firstOrNull);
        if (failureRoute != null) {
          context.push(failureRoute);
        }
        return;
      }

      final leadOrderId =
          payData['leadOrderId']?.toString() ?? orderIds.first;
      final batchTotal = payData['batchTotalAmount'] ?? payData['amount'];
      final orderNumbersRaw = payData['orderNumbers'];
      final checkoutBatchNumber =
          payData['checkoutBatchNumber']?.toString().trim();
      final orderNumbers = orderNumbersRaw is List
          ? orderNumbersRaw.map((e) => e.toString()).toList()
          : <String>[];
      final orderLabel = checkoutBatchNumber?.isNotEmpty == true
          ? checkoutBatchNumber!
          : (orderNumbers.length > 1
              ? 'cart.batch_checkout_label'.tr(
                  namedArgs: {'count': '${orderNumbers.length}'},
                )
              : (orderNumbers.isNotEmpty
                  ? orderNumbers.first
                  : (orders.first['orderNumber']?.toString() ??
                      'cart.checkout_label'.tr())));

      if (!context.mounted) return;
      context.pushReplacement(
        '/payment-instruction',
        extra: {
          'orderId': leadOrderId,
          'orderNumber': orderLabel,
          'amount': batchTotal,
          'paymentResult': payData,
          if (orderIds.length > 1) 'batchOrderIds': orderIds,
        },
      );
      unawaited(commerceCubit.loadCart());
      return;
    }

    setState(() => _isCheckingOut = false);
    await commerceCubit.loadCart();
    if (mounted) {
      setState(() {
        for (final it in selectedItems) {
          _selectedItemIds.remove(it.id);
        }
      });
    }
    if (!context.mounted) return;

    final count = orders.length;
    showSuccessSnackBar(
      context,
      count > 1
          ? 'cart.orders_created_batch'.tr(namedArgs: {'count': '$count'})
          : 'cart.order_created_continue'.tr(),
      duration: const Duration(seconds: 3),
    );

    context.push(
      '/checkout-result',
      extra: {'orders': orders},
    );
  }

  void _goToCheckoutPage(BuildContext context, CartSummary cart) {
    final selectedItems = cart.items
        .where((it) => _selectedItemIds.contains(it.id))
        .toList();
    if (selectedItems.isEmpty) {
      showWarningSnackBar(context, 'cart.snack_select_min_one'.tr());
      return;
    }
    if (_anySelectedOutOfStock(cart)) {
      showErrorSnackBar(context, 'cart.snack_out_of_stock_selection'.tr());
      return;
    }
    context.push(
      '/checkout-result',
      extra: {'selectedItemIds': _selectedItemIds.toList()},
    );
  }

  List<Map<String, dynamic>> _buildShippingSelectionsForCheckout(
    List<CartItemModel> selectedItems,
  ) {
    if (selectedItems.isEmpty) return const [];
    final bySeller = <String, List<CartItemModel>>{};
    for (final it in selectedItems) {
      final sid = it.product.toEntity().seller.id;
      bySeller.putIfAbsent(sid, () => []).add(it);
    }
    return bySeller.entries
        .map((entry) {
          final sel = _shippingSelectionBySeller[entry.key];
          if (sel == null) return null;
          return {
            ...sel,
            'sellerId': entry.key,
            'weightGrams': _estimateWeightGrams(entry.value),
          };
        })
        .whereType<Map<String, dynamic>>()
        .toList();
  }

  String _cartContentKey(CartSummary cart) {
    final parts = cart.items.map((it) => '${it.id}:${it.quantity}').toList()
      ..sort();
    return parts.join('|');
  }

  bool _shouldScheduleCheckoutPreview(CartSummary cart) {
    if (!_isCheckoutFlow || _isCheckingOut || _checkoutPreviewLoading) {
      return false;
    }
    final selectedItems = cart.items
        .where((it) => _selectedItemIds.contains(it.id))
        .toList();
    if (selectedItems.isEmpty) return false;

    final requiredSellerCount = selectedItems
        .map((it) => it.product.toEntity().seller.id)
        .toSet()
        .length;
    if (_buildShippingSelectionsForCheckout(selectedItems).length !=
        requiredSellerCount) {
      return false;
    }

    final shippingPayload = _checkoutShippingPayload();
    if ((shippingPayload.shippingAddress?.length ?? 0) < 10) return false;

    final key = _buildCheckoutPreviewInputKey(cart);
    if (key == _lastCheckoutPreviewKey) return false;
    return true;
  }

  String _buildCheckoutPreviewInputKey(CartSummary cart) {
    final selected = cart.items
        .where((it) => _selectedItemIds.contains(it.id))
        .toList()
      ..sort((a, b) => a.id.compareTo(b.id));
    final parts = selected.map((it) => '${it.id}:${it.quantity}').toList();
    final shipKeys = _shippingSelectionBySeller.keys.toList()..sort();
    for (final sellerId in shipKeys) {
      final s = _shippingSelectionBySeller[sellerId]!;
      parts.add(
        '$sellerId:${s['weightGrams']}:${s['cost']}:${s['courierCode']}:${s['serviceCode']}',
      );
    }
    return parts.join('|');
  }

  void _scheduleCheckoutPreviewRefresh(CartSummary cart) {
    _checkoutPreviewDebounce?.cancel();
    _checkoutPreviewDebounce = Timer(const Duration(milliseconds: 350), () {
      if (!mounted) return;
      _handleCheckoutInputsChanged(cart);
    });
  }

  Future<void> _handleCheckoutInputsChanged(CartSummary cart) async {
    if (!_isCheckoutFlow) return;
    await _syncShippingCostsAfterQuantityChange(cart);
    if (!mounted) return;

    final selectedItems = cart.items
        .where((it) => _selectedItemIds.contains(it.id))
        .toList();
    final requiredSellerCount = selectedItems
        .map((it) => it.product.toEntity().seller.id)
        .toSet()
        .length;
    if (_buildShippingSelectionsForCheckout(selectedItems).length !=
        requiredSellerCount) {
      return;
    }

    final key = _buildCheckoutPreviewInputKey(cart);
    if (key == _lastCheckoutPreviewKey && _checkoutPreview != null) return;
    await _refreshCheckoutPreview(cart);
  }

  Future<void> _syncShippingCostsAfterQuantityChange(CartSummary cart) async {
    final selectedItems = cart.items
        .where((it) => _selectedItemIds.contains(it.id))
        .toList();
    if (selectedItems.isEmpty) return;

    final bySeller = <String, List<CartItemModel>>{};
    for (final it in selectedItems) {
      final sid = it.product.toEntity().seller.id;
      bySeller.putIfAbsent(sid, () => []).add(it);
    }

    final orderCubit = context.read<OrderCubit>();

    for (final entry in bySeller.entries) {
      final sellerId = entry.key;
      final sel = _shippingSelectionBySeller[sellerId];
      if (sel == null) continue;

      final newWeight = _estimateWeightGrams(entry.value);
      final oldWeight = (sel['weightGrams'] as num?)?.toInt() ?? 0;
      if (newWeight == oldWeight) continue;

      final originId = (sel['originId'] as num?)?.toInt();
      final destinationId = (sel['destinationId'] as num?)?.toInt();
      final courierCode = sel['courierCode']?.toString() ?? '';
      if (originId == null || destinationId == null || courierCode.isEmpty) {
        continue;
      }

      try {
        final options = await orderCubit.calculateDomesticShipping(
          originId: originId,
          destinationId: destinationId,
          weightGrams: newWeight,
          courier: courierCode,
        );
        if (!mounted) return;

        final serviceCode = sel['serviceCode']?.toString();
        final serviceName = sel['serviceName']?.toString();
        Map<String, dynamic>? match;
        for (final opt in options) {
          final sameCourier =
              opt['code']?.toString().toLowerCase() == courierCode.toLowerCase();
          if (!sameCourier) continue;
          final svc = opt['service']?.toString();
          final desc = opt['description']?.toString();
          if (serviceCode != null && serviceCode.isNotEmpty) {
            if (svc == serviceCode || desc == serviceCode) {
              match = opt;
              break;
            }
          } else if (serviceName != null &&
              (svc == serviceName || desc == serviceName)) {
            match = opt;
            break;
          }
        }
        match ??= options.cast<Map<String, dynamic>?>().firstWhere(
              (o) =>
                  o?['code']?.toString().toLowerCase() ==
                  courierCode.toLowerCase(),
              orElse: () => null,
            );

        if (match == null) {
          setState(() {
            _shippingSelectionBySeller.remove(sellerId);
            _shippingErrorBySeller[sellerId] =
                'cart.weight_changed_reselect'.tr();
            _checkoutPreview = null;
            _lastCheckoutPreviewKey = null;
          });
          continue;
        }

        setState(() {
          _shippingSelectionBySeller[sellerId] = {
            ...sel,
            'weightGrams': newWeight,
            'cost': (match!['cost'] as num?)?.toDouble() ??
                double.tryParse(match['cost']?.toString() ?? '0') ??
                0,
            'serviceCode': match['service']?.toString() ?? sel['serviceCode'],
            'serviceName': match['description']?.toString() ??
                match['service']?.toString() ??
                sel['serviceName'],
            'etd': match['etd']?.toString() ?? sel['etd'],
          };
          _checkoutPreview = null;
          _lastCheckoutPreviewKey = null;
        });
      } catch (_) {
        if (!mounted) return;
        setState(() {
          _shippingErrorBySeller[sellerId] =
              'cart.recalc_shipping_failed'.tr();
          _checkoutPreview = null;
          _lastCheckoutPreviewKey = null;
        });
      }
    }
  }

  Future<void> _refreshCheckoutPreview(
    CartSummary cart, {
    bool force = false,
  }) async {
    final selectedItems = cart.items
        .where((it) => _selectedItemIds.contains(it.id))
        .toList();
    if (selectedItems.isEmpty) {
      if (!mounted) return;
      setState(() {
        _checkoutPreview = null;
        _checkoutPreviewError = null;
        _checkoutPreviewLoading = false;
      });
      return;
    }

    final shippingSelections = _buildShippingSelectionsForCheckout(selectedItems);
    final requiredSellerCount = selectedItems
        .map((it) => it.product.toEntity().seller.id)
        .toSet()
        .length;
    if (shippingSelections.length != requiredSellerCount) {
      if (!mounted) return;
      setState(() {
        _checkoutPreview = null;
        _checkoutPreviewError = null;
        _checkoutPreviewLoading = false;
      });
      return;
    }

    final items = selectedItems
        .map((it) => {
              'productId': it.product.toEntity().id,
              'quantity': it.quantity,
            })
        .toList();
    final shippingPayload = _checkoutShippingPayload();
    if (shippingPayload.shippingAddress == null ||
        shippingPayload.shippingAddress!.length < 10) {
      if (!mounted) return;
      setState(() {
        _checkoutPreview = null;
        _checkoutPreviewError = null;
        _checkoutPreviewLoading = false;
        _lastCheckoutPreviewKey = null;
      });
      return;
    }

    final key = _buildCheckoutPreviewInputKey(cart);
    if (!force &&
        key == _lastCheckoutPreviewKey &&
        (_checkoutPreview != null || _checkoutPreviewError != null)) {
      return;
    }

    final requestId = ++_checkoutPreviewRequestId;
    setState(() {
      _checkoutPreviewLoading = true;
      _checkoutPreviewError = null;
    });
    final preview = await context.read<OrderCubit>().previewDirectOrder(
          items: items,
          shippingAddress: shippingPayload.shippingAddress,
          shippingSnapshot: shippingPayload.shippingSnapshot,
          shippingSelections: shippingSelections,
          voucherCode: _appliedVoucherCode,
        );
    if (!mounted || requestId != _checkoutPreviewRequestId) return;
    setState(() {
      _checkoutPreviewLoading = false;
      _lastCheckoutPreviewKey = key;
      if (preview != null) {
        _checkoutPreview = preview;
        _checkoutPreviewError = null;
      } else {
        _checkoutPreviewError = 'cart.preview_load_failed'.tr();
      }
    });
  }

  Future<void> _calculateSellerShipping(_SellerGroup group) async {
    if (_shippingAddressQuery == null || _shippingAddressQuery!.isEmpty) {
      showWarningSnackBar(
        context,
        _locationError ?? 'cart.complete_address_for_shipping'.tr(),
      );
      return;
    }

    setState(() {
      _shippingLoadingSellerIds.add(group.seller.id);
      _shippingErrorBySeller.remove(group.seller.id);
    });

    try {
      final orderCubit = context.read<OrderCubit>();
      final defaultDestinationQuery = (_shippingAddressQuery?.isNotEmpty ?? false)
          ? _shippingAddressQuery!
          : ((_shippingFix?.address?.isNotEmpty ?? false)
                ? _shippingFix!.address!
                : _shippingFix!.shortLabel);
      final destinationQuery =
          _destinationQueryBySeller[group.seller.id] ?? defaultDestinationQuery;
      final destination = await _resolveBuyerDestination(
        orderCubit,
        destinationQuery,
      );
      final buyerDestinationLabel = (_shippingFullAddress?.trim().isNotEmpty ?? false)
          ? _shippingFullAddress!.trim()
          : (_selectedProfileAddress != null
              ? _displayLineFromEntity(_selectedProfileAddress!)
              : destinationQuery.trim());
      final origin = await _resolveSellerOrigin(orderCubit, group);
      final originId = int.tryParse(origin?['id']?.toString() ?? '');
      final originLabel = origin?['label']?.toString();

      final destinationId = int.tryParse(destination?['id']?.toString() ?? '');
      if (originId == null || destinationId == null) {
        final sellerName = group.seller.companyName?.isNotEmpty == true
            ? group.seller.companyName!
            : group.seller.name;
        throw Exception(
          'cart.shipping_origin_not_found'.tr(
            namedArgs: {'seller': sellerName},
          ),
        );
      }

      final weightGrams = _estimateWeightGrams(group.items);
      final courierCode = _courierBySeller[group.seller.id];
      final options = await orderCubit.calculateDomesticShipping(
        originId: originId,
        destinationId: destinationId,
        weightGrams: weightGrams,
        courier: courierCode,
      );

      if (!mounted) return;
      if (options.isEmpty) {
        throw Exception('cart.courier_unavailable'.tr());
      }

      final selected = await _pickShippingOptionSheet(
        options: options,
        sellerName: group.seller.companyName?.isNotEmpty == true
            ? group.seller.companyName!
            : group.seller.name,
      );
      if (!mounted || selected == null) return;

      setState(() {
        _shippingSelectionBySeller[group.seller.id] = {
          'sellerId': group.seller.id,
          'originId': originId,
          'originLabel': originLabel,
          'destinationId': destinationId,
          // Label tujuan pakai alamat buyer (GPS/Map/Profil), bukan label mentah RajaOngkir.
          'destinationLabel': buyerDestinationLabel.isNotEmpty
              ? buyerDestinationLabel
              : destination?['label']?.toString(),
          'weightGrams': weightGrams,
          'courierCode': selected['code']?.toString() ?? '',
          'serviceCode': selected['service']?.toString(),
          'serviceName': selected['description']?.toString() ??
              selected['service']?.toString(),
          'cost': (selected['cost'] as num?)?.toDouble() ??
              double.tryParse(selected['cost']?.toString() ?? '0') ??
              0,
          'etd': selected['etd']?.toString(),
        };
      });
      await _refreshCheckoutPreview(context.read<CommerceCubit>().state.cart!);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _shippingErrorBySeller[group.seller.id] = e.toString().replaceFirst(
              'Exception: ',
              '',
            );
      });
    } finally {
      if (mounted) {
        setState(() => _shippingLoadingSellerIds.remove(group.seller.id));
      }
    }
  }

  /// Maksimal satu panggilan API per resolusi lokasi (hemat kuota RajaOngkir).
  List<String> _destinationSearchAttempts(String query) {
    final normalized = _normalizeRajaOngkirSearch(query);
    if (!_looksLikeLocationQuery(normalized)) return const [];

    final fix = _shippingFix;
    if (fix != null &&
        (fix.city?.isNotEmpty ?? false) &&
        (fix.province?.isNotEmpty ?? false)) {
      final gpsQuery = _normalizeRajaOngkirSearch('${fix.city}, ${fix.province}');
      if (gpsQuery.toLowerCase() != normalized.toLowerCase() &&
          _looksLikeLocationQuery(gpsQuery)) {
        return [normalized, gpsQuery];
      }
    }
    return [normalized];
  }

  Future<List<Map<String, dynamic>>> _searchDestinationsCached(
    OrderCubit orderCubit,
    String attempt,
  ) async {
    if (_shippingQuotaExceeded) return const [];

    final keyword = _normalizeRajaOngkirSearch(attempt);
    if (!_looksLikeLocationQuery(keyword)) return const [];

    final cached = ShippingDestinationCache.instance.get(keyword);
    if (cached != null) return cached;

    final result = await orderCubit.searchShippingDestinations(
      search: keyword,
      limit: 10,
    );
    if (result.quotaExceeded) {
      if (mounted) {
        setState(() {
          _shippingQuotaExceeded = true;
          _shippingQuotaMessage = result.errorMessage;
        });
      }
      return const [];
    }

    ShippingDestinationCache.instance.put(keyword, result.items);
    return result.items;
  }

  int _scoreDestinationCandidate(String query, Map<String, dynamic> candidate) {
    final label = (candidate['label'] ?? candidate['name'] ?? '')
        .toString()
        .toLowerCase();
    final normalizedQuery = query.toLowerCase();
    var score = 0;

    final tokens = normalizedQuery
        .split(RegExp(r'[,\s]+'))
        .map((token) => token.trim())
        .where((token) => token.length >= 3)
        .toSet();
    for (final token in tokens) {
      if (label.contains(token)) score += 12;
    }

    final fix = _shippingFix;
    final city = fix?.city?.toLowerCase();
    final province = fix?.province?.toLowerCase();
    if (city != null && city.isNotEmpty && label.contains(city)) score += 35;
    if (province != null && province.isNotEmpty && label.contains(province)) {
      score += 20;
    }

    // Hindari lokasi yang tidak relevan dengan query buyer.
    const riskyPlaces = ['dairi', 'jambi', 'medan', 'jakarta', 'surabaya'];
    for (final risky in riskyPlaces) {
      if (label.contains(risky) && !normalizedQuery.contains(risky)) {
        score -= 40;
      }
    }
    return score;
  }

  Future<Map<String, dynamic>?> _resolveBuyerDestination(
    OrderCubit orderCubit,
    String query,
  ) async {
    final normalized = _normalizeRajaOngkirSearch(query);
    if (normalized.isEmpty) return null;
    if (_cachedBuyerDestination != null &&
        _cachedBuyerDestinationQuery == normalized) {
      return _cachedBuyerDestination;
    }
    final resolved = await _resolveShippingPoint(orderCubit, normalized);
    _cachedBuyerDestinationQuery = normalized;
    _cachedBuyerDestination = resolved;
    return resolved;
  }

  Future<Map<String, dynamic>?> _resolveShippingPoint(
    OrderCubit orderCubit,
    String query,
  ) async {
    if (_shippingQuotaExceeded) {
      throw Exception(
        _shippingQuotaMessage ??
            'cart.api_quota_exhausted'.tr(),
      );
    }

    final normalized = _normalizeRajaOngkirSearch(query);
    if (normalized.isEmpty) return null;

    final attempts = _destinationSearchAttempts(normalized);
    if (attempts.isEmpty) return null;

    final candidates = <String, Map<String, dynamic>>{};
    for (final attempt in attempts) {
      final found = await _searchDestinationsCached(orderCubit, attempt);
      for (final item in found) {
        final id = item['id']?.toString();
        if (id == null || id.isEmpty) continue;
        candidates.putIfAbsent(id, () => item);
      }
      if (candidates.isNotEmpty || _shippingQuotaExceeded) break;
    }
    if (candidates.isEmpty) return null;

    Map<String, dynamic>? best;
    var bestScore = -999999;
    for (final candidate in candidates.values) {
      final score = _scoreDestinationCandidate(normalized, candidate);
      if (score > bestScore) {
        bestScore = score;
        best = candidate;
      }
    }
    return best;
  }

  Future<Map<String, dynamic>?> _resolveSellerOrigin(
    OrderCubit orderCubit,
    _SellerGroup group,
  ) async {
    if (group.seller.rajaongkirOriginId != null) {
      return {
        'id': group.seller.rajaongkirOriginId,
        'label': group.seller.rajaongkirOriginLabel ?? group.seller.companyName ?? group.seller.name,
      };
    }

    final firstProduct = group.items.first.product.toEntity();
    String? originQuery;
    if (group.seller.rajaongkirOriginLabel?.trim().isNotEmpty ?? false) {
      originQuery = group.seller.rajaongkirOriginLabel!.trim();
    } else if ((firstProduct.regency?.isNotEmpty ?? false) &&
        firstProduct.province.isNotEmpty) {
      originQuery = '${firstProduct.regency}, ${firstProduct.province}';
    }

    if (originQuery == null) return null;
    return _resolveShippingPoint(orderCubit, originQuery);
  }

  Future<void> _editDestinationQuery(_SellerGroup group) async {
    final picked = await OsmLocationPickerPage.open(context);
    if (!mounted || picked == null) return;
    final value = picked.formattedAddress.trim();
    if (value.isEmpty) return;
    setState(() {
      _destinationQueryBySeller[group.seller.id] = value;
      _shippingSelectionBySeller.remove(group.seller.id);
      _checkoutPreview = null;
    });
  }

  Future<void> _pickSavedShippingAddress() async {
    final repo = sl<AuthRepository>();
    final result = await repo.getAddresses();
    if (!mounted) return;
    final addresses = result.fold((_) => const [], (items) => items);
    if (addresses.isEmpty) {
      showWarningSnackBar(context, 'cart.no_profile_address'.tr());
      return;
    }

    final selected = await showModalBottomSheet<AddressEntity>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (ctx) => SafeArea(
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: addresses.length,
          separatorBuilder: (_, __) => Divider(
            height: 1.h,
            color: AppColors.grey100,
          ),
          itemBuilder: (_, i) {
            final a = addresses[i];
            final label =
                a.name.isNotEmpty
                    ? a.name
                    : (a.city.isNotEmpty
                        ? a.city
                        : 'cart.address_fallback'.tr());
            return ListTile(
              title: Text(label),
              subtitle: Text(
                _displayLineFromEntity(a),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: a.isPrimary
                  ? Text(
                      'cart.primary_badge'.tr(),
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 11.sp,
                      ),
                    )
                  : null,
              onTap: () => safeNavigatorPop(ctx, a),
            );
          },
        ),
      ),
    );
    if (!mounted || selected == null) return;
    _applyProfileAddress(selected);
  }

  Future<void> _pickShippingAddressFromMap() async {
    final picked = await OsmLocationPickerPage.open(context);
    if (!mounted || picked == null) return;
    final query = picked.formattedAddress.trim();
    if (query.isEmpty) return;
    setState(() {
      _selectedProfileAddress = null;
      _usingPrimaryProfile = false;
      _shippingAddressLabel = query;
      _shippingAddressQuery = query;
      _shippingFullAddress =
          query.length >= 10 ? query : null;
      _shippingFix = null;
      _locationError = null;
      _clearShippingSelections();
    });
  }

  Future<void> _pickCourierForSeller(_SellerGroup group) async {
    final cubit = context.read<OrderCubit>();
    final couriers = await cubit.getActiveCouriers();
    if (!mounted) return;
    if (couriers.isEmpty) {
      showWarningSnackBar(context, 'cart.no_couriers'.tr());
      return;
    }
    final selected = await showModalBottomSheet<String>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (ctx) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              title: Text('cart.all_couriers_active'.tr()),
              subtitle: Text('cart.all_couriers_hint'.tr()),
              onTap: () => safeNavigatorPop(ctx, ''),
            ),
            ...couriers.map(
              (code) => ListTile(
                title: Text(code.toUpperCase()),
                onTap: () => safeNavigatorPop(ctx, code),
              ),
            ),
          ],
        ),
      ),
    );
    if (!mounted || selected == null) return;
    setState(() {
      if (selected.isEmpty) {
        _courierBySeller.remove(group.seller.id);
      } else {
        _courierBySeller[group.seller.id] = selected;
      }
      _shippingSelectionBySeller.remove(group.seller.id);
      _checkoutPreview = null;
      _checkoutPreviewError = null;
    });
  }

  int _estimateWeightGrams(List<CartItemModel> items) {
    final total = items.fold<double>(0, (sum, item) {
      final p = item.product.toEntity();
      final gramPerUnit = p.technicalSpec?.grossWeightPerSak != null
          ? ((p.technicalSpec!.grossWeightPerSak!) * 1000)
          : 1000;
      return sum + (gramPerUnit * item.quantity);
    });
    return total.round().clamp(1, 500000);
  }

  Future<Map<String, dynamic>?> _pickShippingOptionSheet({
    required List<Map<String, dynamic>> options,
    required String sellerName,
  }) async {
    return showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.xl,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'cart.pick_courier_title'.tr(
                  namedArgs: {'seller': sellerName},
                ),
                style: AppTextStyles.sectionTitle(fontWeight: FontWeight.w800),
              ),
              SizedBox(height: AppSpacing.sm10),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 360.h),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: options.length,
                  separatorBuilder: (_, __) => SizedBox(height: AppSpacing.sm),
                  itemBuilder: (_, idx) {
                    final option = options[idx];
                    final cost = (option['cost'] as num?)?.toDouble() ??
                        double.tryParse(option['cost']?.toString() ?? '0') ??
                        0;
                    final code = option['code']?.toString().toUpperCase() ?? '-';
                    final service = option['service']?.toString() ?? '-';
                    final description = option['description']?.toString() ?? service;
                    final etd = option['etd']?.toString() ?? '-';

                    return InkWell(
                      onTap: () => safeNavigatorPop(ctx, option),
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      child: Container(
                        padding: EdgeInsets.all(AppSpacing.md12),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.grey200),
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$code - $service',
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              description,
                              style: AppTextStyles.bodySecondary(color: AppColors.textSecondary),
                            ),
                            SizedBox(height: 6.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  formatMoneyIdr(cost),
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  'cart.etd_days'.tr(namedArgs: {'etd': etd}),
                                  style: AppTextStyles.caption(color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _detectShippingLocation() async {
    if (_detectingLocation) return;
    setState(() {
      _detectingLocation = true;
      _locationError = null;
    });

    final perm = await LocationService.instance.ensurePermission();
    if (perm != LocationPermissionResult.granted) {
      if (!mounted) return;
      setState(() {
        _detectingLocation = false;
        _locationError = switch (perm) {
          LocationPermissionResult.deniedForever =>
            'cart.location_denied_forever'.tr(),
          LocationPermissionResult.serviceDisabled =>
            'cart.location_gps_off'.tr(),
          _ => 'cart.location_denied'.tr(),
        };
      });
      showWarningSnackBar(context, _locationError!);
      if (perm == LocationPermissionResult.deniedForever) {
        await Geolocator.openAppSettings();
      } else if (perm == LocationPermissionResult.serviceDisabled) {
        await Geolocator.openLocationSettings();
      }
      return;
    }

    final fix = await LocationService.instance.getCurrentFix();
    if (!mounted) return;
    setState(() {
      _detectingLocation = false;
      _selectedProfileAddress = null;
      _usingPrimaryProfile = false;
      _shippingFix = fix;
      _shippingAddressLabel = fix?.shortLabel;
      // Untuk pencarian RajaOngkir, prioritaskan kota+provinsi agar tidak salah ke lokasi lain.
      if (fix != null &&
          (fix.city?.isNotEmpty ?? false) &&
          (fix.province?.isNotEmpty ?? false)) {
        _shippingAddressQuery = '${fix.city}, ${fix.province}';
      } else if ((fix?.address?.isNotEmpty ?? false) &&
          _looksLikeLocationQuery(fix!.address!)) {
        _shippingAddressQuery = fix.address;
      } else {
        _shippingAddressQuery = null;
        _locationError = 'cart.gps_no_city'.tr();
      }
      _shippingFullAddress = (fix?.address?.trim().isNotEmpty ?? false)
          ? fix!.address!.trim()
          : _shippingAddressQuery;
      _locationError = fix == null
          ? 'cart.gps_failed'.tr()
          : null;
      _clearShippingSelections();
    });
    if (fix == null) {
      showErrorSnackBar(context, _locationError!);
    }
  }

  /// Tampilkan toast "Stok habis / Maksimal stok".
  void _showStockToast(BuildContext context, ProductEntity p) {
    if (_stockToastShown.contains(p.id)) return;
    _stockToastShown.add(p.id);

    clearBisaSnackBars(context);
    final isEmpty = p.stock <= 0;
    showCustomSnackBar(
      context,
      backgroundColor: isEmpty ? AppColors.error : AppColors.warning,
      duration: const Duration(milliseconds: 2200),
      content: Row(
        children: [
          Icon(
            isEmpty ? LucideIcons.packageX : LucideIcons.triangleAlert,
            color: AppColors.surface,
            size: 20.sp,
          ),
          SizedBox(width: AppSpacing.sm10),
          Expanded(
            child: Text(
              isEmpty
                  ? 'cart.stock_empty'.tr(namedArgs: {'name': p.name})
                  : 'cart.stock_max'.tr(
                      namedArgs: {
                        'qty': _formatQty(p.stock),
                        'unit': p.unit,
                      },
                    ),
              style: TextStyle(
                color: AppColors.surface,
                fontWeight: FontWeight.w700,
                fontSize: 13.sp,
              ),
            ),
          ),
        ],
      ),
    );
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) _stockToastShown.remove(p.id);
    });
  }

  String _formatQty(double v) {
    if (v == v.roundToDouble()) return v.toInt().toString();
    return v.toStringAsFixed(1);
  }

  Widget _buildCartLoadingSkeleton() {
    return ListView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md12,
        AppSpacing.md,
        AppSpacing.xl,
      ),
      children: [
        ShimmerLoading(
          child: Column(
            children: List.generate(4, (i) {
              return Padding(
                padding: EdgeInsets.only(bottom: i < 3 ? AppSpacing.md : 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Bone(
                      width: 76.w,
                      height: 76.w,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                    SizedBox(width: AppSpacing.md12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Bone(width: double.infinity, height: 14.h),
                          SizedBox(height: AppSpacing.sm),
                          Bone(width: 120.w, height: 12.h),
                          SizedBox(height: AppSpacing.sm),
                          Bone(width: 80.w, height: 16.h),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: BisaAppBar(
        title: _isCheckoutFlow
            ? 'cart.checkout_title'.tr()
            : 'cart.title'.tr(),
        backgroundColor: AppColors.surface,
        onBackTap: _isCheckoutFlow
            ? () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/cart');
                }
              }
            : null,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          BlocConsumer<CommerceCubit, CommerceState>(
        listenWhen: (prev, curr) {
          if (curr.error != null && curr.error != prev.error) return true;
          if (!_isCheckoutFlow || _isCheckingOut) return false;
          if (curr.cart == null) return false;
          if (prev.cart == null) return true;
          return _cartContentKey(prev.cart!) != _cartContentKey(curr.cart!);
        },
        listener: (context, state) {
          if (state.error != null && state.error != _lastCommerceErrorSnack) {
            _lastCommerceErrorSnack = state.error;
            showFailureSnackBarFromMessage(context, state.error!);
          } else if (state.error == null) {
            _lastCommerceErrorSnack = null;
          }
          if (state.cart != null && _shouldScheduleCheckoutPreview(state.cart!)) {
            _scheduleCheckoutPreviewRefresh(state.cart!);
          }
        },
        builder: (context, state) {
          if (state.isLoading && state.cart == null) {
            return _buildCartLoadingSkeleton();
          }

          final cart = state.cart;
          if (cart == null || cart.items.isEmpty) {
            if (_isCheckoutFlow && _isCheckingOut) {
              return const SizedBox.shrink();
            }
            return _buildEmpty(context);
          }

          _syncSelection(cart);

          // Group items by seller id supaya tampilan rapi per pemilik produk.
          final groups = <String, _SellerGroup>{};
          for (final item in cart.items) {
            final p = item.product.toEntity();
            final sid = p.seller.id;
            groups.putIfAbsent(
              sid,
              () => _SellerGroup(seller: p.seller, items: []),
            );
            groups[sid]!.items.add(item);
          }

          final groupList = groups.values.toList();
          final hasOutOfStock = cart.items.any(
            (it) => it.product.toEntity().stock <= 0,
          );

          final selectedItems = cart.items
              .where((it) => _selectedItemIds.contains(it.id))
              .toList();
          if (_isCheckoutFlow) {
            final checkoutGroups = groupList
                .map((g) => _SellerGroup(
                      seller: g.seller,
                      items: g.items
                          .where((it) => _selectedItemIds.contains(it.id))
                          .toList(),
                    ))
                .where((g) => g.items.isNotEmpty)
                .toList();

            return Column(
              children: [
                if (hasOutOfStock && _anySelectedOutOfStock(cart))
                  _buildOutOfStockBanner(),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      AppSpacing.md12,
                      AppSpacing.md,
                      AppSpacing.md,
                    ),
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    children: [
                      _buildShippingLocationCard(),
                      SizedBox(height: AppSpacing.md12),
                      _buildPaymentMethodCard(),
                      SizedBox(height: AppSpacing.md12),
                      for (var i = 0; i < checkoutGroups.length; i++) ...[
                        if (i > 0) SizedBox(height: AppSpacing.section),
                        _buildSellerCard(context, checkoutGroups[i],
                            showShipping: true),
                      ],
                    ],
                  ),
                ),
                _buildCheckoutBar(context, cart, hasOutOfStock),
              ],
            );
          }

          // Tentukan dominant productMode untuk filter rekomendasi.
          final modeCount = <String, int>{};
          for (final it in cart.items) {
            final mode = it.product.toEntity().productMode;
            modeCount[mode] = (modeCount[mode] ?? 0) + 1;
          }
          final dominantMode = modeCount.entries
              .toList()
              .reduce((a, b) => a.value >= b.value ? a : b)
              .key;
          final excludeIds =
              cart.items.map((e) => e.product.toEntity().id).toSet();

          return Column(
            children: [
              if (hasOutOfStock) _buildOutOfStockBanner(),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    AppSpacing.md,
                    AppSpacing.md,
                    AppSpacing.md,
                  ),
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  children: [
                    for (var i = 0; i < groupList.length; i++) ...[
                      if (i > 0) SizedBox(height: AppSpacing.section),
                      _buildSellerCard(context, groupList[i],
                          showShipping: false),
                    ],
                    SizedBox(height: AppSpacing.md),
                    _CartRecommendationSection(
                      productMode: dominantMode,
                      excludeIds: excludeIds,
                    ),
                    SizedBox(height: AppSpacing.sm),
                    DualModeProductCatalog(
                      excludeIds: excludeIds,
                      limitPerMode: 20,
                    ),
                  ],
                ),
              ),
              _buildSimpleCartBar(context, cart, hasOutOfStock),
            ],
          );
        },
      ),
          if (_isCheckoutFlow && _isCheckingOut)
            _buildCheckoutProcessingOverlay(),
        ],
      ),
    );
  }

  /// Menutupi layar saat order dibuat + VA/QR digenerate — hindari flash "keranjang kosong".
  Widget _buildCheckoutProcessingOverlay() {
    return ColoredBox(
      color: AppColors.background.withValues(alpha: 0.96),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 40.w,
                height: 40.w,
                child: const CircularProgressIndicator(
                  strokeWidth: 3,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: AppSpacing.lg),
              Text(
                'cart.processing_payment'.tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                'cart.processing_wait'.tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.textSecondary,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.shoppingCart, size: 64.sp, color: AppColors.grey300),
          SizedBox(height: AppSpacing.md),
          Text(
            'cart.empty_title'.tr(),
            style: AppTextStyles.sectionTitle(),
          ),
          SizedBox(height: AppSpacing.sm),
          TextButton(
            onPressed: () => context.go('/'),
            child: Text('cart.empty_cta'.tr()),
          ),
        ],
      ),
    );
  }

  Widget _buildOutOfStockBanner() {
    return Container(
      width: double.infinity,
      color: AppColors.error.withValues(alpha: 0.08),
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm10,
      ),
      child: Row(
        children: [
          Icon(LucideIcons.packageX, color: AppColors.error, size: 18.sp),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'cart.out_of_stock_banner'.tr(),
              style: TextStyle(
                color: AppColors.error,
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSellerCard(
    BuildContext context,
    _SellerGroup group, {
    required bool showShipping,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: AppColors.softShadow,
      ),
      child: Column(
        children: [
          _buildSellerHeader(context, group.seller, group.items),
          if (showShipping) ...[
            Divider(height: 1.h, color: AppColors.grey100),
            _buildSellerShippingCard(group),
          ],
          Divider(height: 1.h, color: AppColors.grey100),
          ...List.generate(group.items.length, (i) {
            final item = group.items[i];
            return Column(
              children: [
                _buildCartItem(context, item),
                if (i != group.items.length - 1)
                  Divider(
                    height: 1.h,
                    color: AppColors.grey100,
                    indent: AppSpacing.md,
                    endIndent: AppSpacing.md,
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSellerShippingCard(_SellerGroup group) {
    final selection = _shippingSelectionBySeller[group.seller.id];
    final isLoading = _shippingLoadingSellerIds.contains(group.seller.id);
    final error = _shippingErrorBySeller[group.seller.id];
    final destinationLabel = selection?['destinationLabel']?.toString();
    final courierCode = selection?['courierCode']?.toString().toUpperCase();
    final service = selection?['serviceName']?.toString();
    final etd = selection?['etd']?.toString();
    final cost = selection?['cost'];
    final costValue = cost is num
        ? cost.toDouble()
        : double.tryParse(cost?.toString() ?? '');
    final selectedCourier = _courierBySeller[group.seller.id];

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.section,
        AppSpacing.sm10,
        AppSpacing.section,
        AppSpacing.sm10,
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(AppSpacing.md12),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.12)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(LucideIcons.truck, size: 14.sp, color: AppColors.primary),
                SizedBox(width: 6.w),
                Expanded(
                  child: Text(
                    'cart.shipping_from_supplier'.tr(),
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: isLoading ? null : () => _calculateSellerShipping(group),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2.h),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    isLoading
                        ? 'cart.calculating'.tr()
                        : (selection == null
                            ? 'cart.setup_shipping'.tr()
                            : 'cart.change'.tr()),
                    style: AppTextStyles.caption(fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
            SizedBox(height: 6.h),
            if (selection == null)
              Text(
                error ?? 'cart.no_shipping_selection'.tr(),
                style: AppTextStyles.caption(color: AppColors.textSecondary),
              )
            else
              Text(
                'cart.shipping_detail'.tr(
                  namedArgs: {
                    'courier': courierCode ?? '-',
                    'service': service ?? '-',
                    'cost': costValue != null ? formatMoneyIdr(costValue) : '-',
                    'etd': etd ?? '-',
                    'destination': destinationLabel ?? '-',
                  },
                ),
                style: TextStyle(
                  fontSize: 11.sp,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
            SizedBox(height: 4.h),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: isLoading ? null : () => _pickCourierForSeller(group),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.h),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                icon: Icon(
                  LucideIcons.packageCheck,
                  size: 12.sp,
                  color: AppColors.textSecondary,
                ),
                label: Text(
                  selectedCourier == null
                      ? 'cart.courier_all_active'.tr()
                      : 'cart.courier_selected'.tr(
                          namedArgs: {
                            'courier': selectedCourier.toUpperCase(),
                          },
                        ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption(color: AppColors.textSecondary),
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: isLoading ? null : () => _editDestinationQuery(group),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.h),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                icon: Icon(
                  LucideIcons.mapPinned,
                  size: 12.sp,
                  color: AppColors.textSecondary,
                ),
                label: Text(
                  _destinationQueryBySeller[group.seller.id] == null
                      ? 'cart.pick_destination'.tr()
                      : _destinationQueryBySeller[group.seller.id]!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption(color: AppColors.textSecondary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSellerHeader(
    BuildContext context,
    ProductSellerEntity seller,
    List<CartItemModel> items,
  ) {
    final selectableItems =
        items.where((it) => it.product.toEntity().stock > 0).toList();
    final selectedCount = selectableItems
        .where((it) => _selectedItemIds.contains(it.id))
        .length;
    final allSelected =
        selectableItems.isNotEmpty && selectedCount == selectableItems.length;
    final partiallySelected = selectedCount > 0 && !allSelected;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.sm,
        AppSpacing.sm,
        AppSpacing.md12,
        AppSpacing.sm,
      ),
      child: Row(
        children: [
          // Checkbox pilih semua untuk seller ini (tri-state).
          SizedBox(
            width: 22.w,
            height: 22.w,
            child: Checkbox(
              value: allSelected
                  ? true
                  : (partiallySelected ? null : false),
              tristate: true,
              onChanged: selectableItems.isEmpty
                  ? null
                  : (v) => _toggleGroupSelection(
                        selectableItems,
                        v == true || partiallySelected,
                      ),
              activeColor: AppColors.primary,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.r),
              ),
            ),
          ),
          SizedBox(width: 6.w),
          // Bagian klikable utk navigate ke toko supplier
          Expanded(
            child: InkWell(
              onTap: () => context.push(
                '/supplier/${seller.id}',
                extra: {'name': seller.name},
              ),
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(1.5.r),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.25),
                          width: 1.5,
                        ),
                      ),
                      child: BisaAvatar(
                        imageUrl: seller.avatarUrl,
                        radius: AppRadius.xl,
                        fallbackIcon: LucideIcons.store,
                      ),
                    ),
                    SizedBox(width: AppSpacing.sm10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  seller.companyName?.isNotEmpty == true
                                      ? seller.companyName!
                                      : seller.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              if (seller.isVerified) ...[
                                SizedBox(width: 4.w),
                                Container(
                                  padding: EdgeInsets.all(2.r),
                                  decoration: const BoxDecoration(
                                    color: AppColors.secondary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.check,
                                    color: AppColors.surface,
                                    size: 8.sp,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'cart.products_selected'.tr(
                              namedArgs: {
                                'total': '${items.length}',
                                'selected': '$selectedCount',
                              },
                            ),
                            style: AppTextStyles.caption(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      LucideIcons.chevronRight,
                      color: AppColors.grey400,
                      size: 18.sp,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, CartItemModel item) {
    final p = item.product.toEntity();
    final stock = p.stock;
    final isOutOfStock = stock <= 0;
    final atStockLimit = !isOutOfStock && item.quantity >= stock;
    final subtotal = p.pricePerUnit * item.quantity;
    final isSelected = _selectedItemIds.contains(item.id);

    return Padding(
      padding: EdgeInsets.all(AppSpacing.section),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Checkbox seleksi
          Padding(
            padding: EdgeInsets.only(top: 4.h, right: 4.w),
            child: SizedBox(
              width: 22.w,
              height: 22.w,
              child: Checkbox(
                value: isSelected,
                onChanged: isOutOfStock
                    ? null
                    : (v) => _toggleItemSelection(item.id, v),
                activeColor: AppColors.primary,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.r),
                ),
              ),
            ),
          ),
          SizedBox(width: 6.w),
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.lg),
                child: BisaNetworkImage(
                  imageUrl: p.thumbnailUrl,
                  width: 76.w,
                  height: 76.w,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => Container(
                    width: 76.w,
                    height: 76.w,
                    color: AppColors.grey100,
                    child: const Icon(LucideIcons.image, color: AppColors.grey400),
                  ),
                ),
              ),
              if (isOutOfStock)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.black.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'cart.stock_out_badge'.tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.surface,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w900,
                        height: 1.1,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(width: AppSpacing.md12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 4.h),
                _buildBadgeRow(p),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Text(
                      formatMoneyIdr(p.pricePerUnit),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      'cart.unit_per'.tr(namedArgs: {'unit': p.unit}),
                      style: AppTextStyles.caption(color: AppColors.textSecondary),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                _buildStockInfo(stock, atStockLimit, isOutOfStock, p.unit),
                SizedBox(height: AppSpacing.sm10),
                // Subtotal di baris sendiri (rata kanan) — mencegah overflow
                // ketika harga punya banyak digit (contoh Rp 9.599.904).
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm10,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(AppRadius.button),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'cart.subtotal'.tr(),
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerRight,
                          child: Text(
                            formatMoneyIdr(subtotal),
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w900,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppSpacing.sm),
                // Action row: qty controls (kiri) + Nego + Hapus (kanan)
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _qtyBtn(
                          LucideIcons.minus,
                          enabled:
                              !isOutOfStock && item.quantity > p.minOrder,
                          onTap: () {
                            if (item.quantity > p.minOrder) {
                              context.read<CommerceCubit>().updateQuantity(
                                    item.id,
                                    item.quantity - 1,
                                  );
                            }
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm10),
                          child: Text(
                            '${_formatQty(item.quantity)} ${p.unit}',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 13.sp,
                            ),
                          ),
                        ),
                        _qtyBtn(
                          LucideIcons.plus,
                          enabled: !isOutOfStock && !atStockLimit,
                          onTap: () {
                            if (isOutOfStock || atStockLimit) {
                              _showStockToast(context, p);
                              return;
                            }
                            final next = item.quantity + 1;
                            if (next > stock) {
                              _showStockToast(context, p);
                              return;
                            }
                            context.read<CommerceCubit>().updateQuantity(
                                  item.id,
                                  next,
                                );
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _miniActionBtn(
                          icon: LucideIcons.messagesSquare,
                          label: 'cart.action_nego'.tr(),
                          color: AppColors.info,
                          onTap: () => context.push('/product/${p.id}'),
                        ),
                        SizedBox(width: 6.w),
                        _miniActionBtn(
                          icon: LucideIcons.trash2,
                          label: 'cart.action_remove'.tr(),
                          color: AppColors.error,
                          onTap: () =>
                              context.read<CommerceCubit>().removeItem(item.id),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Tombol aksi kecil (Nego / Hapus) di item cart.
  Widget _miniActionBtn({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.button),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 6.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppRadius.button),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 13.sp),
            SizedBox(width: 4.w),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgeRow(ProductEntity p) {
    final badges = <Widget>[];
    badges.add(
      _miniBadge(
        p.productMode == 'ORGANIC_PRODUCE'
            ? 'commerce.mode_organic'.tr()
            : 'commerce.mode_biomass'.tr(),
        p.productMode == 'ORGANIC_PRODUCE'
            ? AppColors.success
            : AppColors.warning,
        icon: p.productMode == 'ORGANIC_PRODUCE'
            ? LucideIcons.sprout
            : LucideIcons.flame,
      ),
    );
    if (p.isCertified) {
      badges.add(_miniBadge('commerce.badge_certified'.tr(), AppColors.info,
          icon: LucideIcons.badgeCheck));
    }
    if (p.isEscrowProtected) {
      badges.add(_miniBadge('commerce.badge_escrow'.tr(), AppColors.primary,
          icon: LucideIcons.shieldCheck));
    }

    return Wrap(
      spacing: 4.w,
      runSpacing: 4.h,
      children: badges,
    );
  }

  Widget _miniBadge(String label, Color color, {IconData? icon}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 10.sp, color: color),
            SizedBox(width: 3.w),
          ],
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 9.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStockInfo(
    double stock,
    bool atLimit,
    bool isOutOfStock,
    String unit,
  ) {
    if (isOutOfStock) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(LucideIcons.packageX, color: AppColors.error, size: 12.sp),
          SizedBox(width: 4.w),
          Text(
            'cart.stock_out'.tr(),
            style: TextStyle(
              color: AppColors.error,
              fontSize: 11.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      );
    }

    if (atLimit) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            LucideIcons.triangleAlert,
            color: AppColors.warning,
            size: 12.sp,
          ),
          SizedBox(width: 4.w),
          Text(
            'cart.stock_max_reached'.tr(
              namedArgs: {
                'qty': _formatQty(stock),
                'unit': unit,
              },
            ),
            style: TextStyle(
              color: AppColors.warning,
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(LucideIcons.package, color: AppColors.textHint, size: 12.sp),
        SizedBox(width: 4.w),
        Text(
          'cart.stock_available'.tr(
            namedArgs: {
              'qty': _formatQty(stock),
              'unit': unit,
            },
          ),
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodCard() {
    final selected = _selectedPayment;
    final previewTotal = _checkoutPreview?['totalAmount'];
    final amount = previewTotal is num
        ? previewTotal
        : num.tryParse(previewTotal?.toString() ?? '') ?? 0;

    return Container(
      margin: EdgeInsets.fromLTRB(
        AppSpacing.md,
        0,
        AppSpacing.md,
        AppSpacing.md12,
      ),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.section,
        AppSpacing.md12,
        AppSpacing.md12,
        AppSpacing.md12,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.tile),
        border: Border.all(
          color: selected != null
              ? AppColors.primary.withValues(alpha: 0.25)
              : AppColors.grey200,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.tile),
        onTap: () async {
          final choice = await PaymentMethodPickerSheet.show(
            context,
            amount: amount,
            initialCode: selected?.code,
          );
          if (choice != null && mounted) {
            setState(() => _selectedPayment = choice);
          }
        },
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(
                LucideIcons.wallet,
                size: 18.sp,
                color: AppColors.primary,
              ),
            ),
            SizedBox(width: AppSpacing.md12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'cart.payment_method'.tr(),
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    selected != null
                        ? 'cart.payment_selected'.tr(
                            namedArgs: {
                              'name': selected.name,
                              'code': selected.code,
                            },
                          )
                        : 'cart.payment_pick_once'.tr(),
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: selected != null
                          ? AppColors.textSecondary
                          : AppColors.warning,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              LucideIcons.chevronRight,
              size: 18.sp,
              color: AppColors.textHint,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShippingLocationCard() {
    final fix = _shippingFix;
    final hasAddress = (_shippingAddressQuery?.isNotEmpty ?? false) ||
        (_shippingFullAddress?.isNotEmpty ?? false) ||
        fix != null;
    final displayAddress = _shippingAddressLabel ??
        (fix != null
            ? fix.shortLabel
            : 'cart.primary_auto_hint'.tr());
    final detailLine = _selectedProfileAddress != null
        ? _displayLineFromEntity(_selectedProfileAddress!)
        : (fix?.address?.trim().isNotEmpty ?? false)
            ? fix!.address!
            : (_shippingFullAddress?.trim().isNotEmpty ?? false)
                ? _shippingFullAddress!
                : null;
    return Container(
      margin: EdgeInsets.fromLTRB(
        AppSpacing.md,
        0,
        AppSpacing.md,
        AppSpacing.md12,
      ),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.section,
        AppSpacing.md12,
        AppSpacing.md12,
        AppSpacing.md12,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.tile),
        border: Border.all(
          color: hasAddress
              ? AppColors.primary.withValues(alpha: 0.25)
              : AppColors.grey200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: (hasAddress ? AppColors.primary : AppColors.warning)
                      .withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(
                  hasAddress ? LucideIcons.mapPin : LucideIcons.mapPinOff,
                  size: 18.sp,
                  color: hasAddress ? AppColors.primary : AppColors.warning,
                ),
              ),
              SizedBox(width: AppSpacing.md12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          'cart.destination_title'.tr(),
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textSecondary,
                            letterSpacing: 0.3,
                          ),
                        ),
                        if (_usingPrimaryProfile) ...[
                          SizedBox(width: 6.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Text(
                              'cart.primary_badge'.tr(),
                              style: TextStyle(
                                fontSize: 9.sp,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      displayAddress,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: hasAddress
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                        height: 1.3,
                      ),
                    ),
                    if (detailLine != null && detailLine.isNotEmpty) ...[
                      SizedBox(height: 2.h),
                      Text(
                        detailLine,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm10),
          Row(
            children: [
              Expanded(
                child: _buildShippingAddressAction(
                  icon: LucideIcons.bookUser,
                  label: 'cart.source_profile'.tr(),
                  highlighted: _selectedProfileAddress != null,
                  onTap: _pickSavedShippingAddress,
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _buildShippingAddressAction(
                  icon: LucideIcons.mapPinned,
                  label: 'cart.source_map'.tr(),
                  highlighted: _shippingFix == null &&
                      _selectedProfileAddress == null &&
                      (_shippingFullAddress?.isNotEmpty ?? false),
                  onTap: _pickShippingAddressFromMap,
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _buildShippingAddressAction(
                  icon: LucideIcons.locateFixed,
                  label: _detectingLocation
                      ? '...'
                      : (_shippingFix != null
                          ? 'cart.source_gps'.tr()
                          : 'cart.source_detect'.tr()),
                  highlighted: _shippingFix != null,
                  loading: _detectingLocation,
                  onTap: _detectingLocation ? null : _detectShippingLocation,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShippingAddressAction({
    required IconData icon,
    required String label,
    required VoidCallback? onTap,
    bool highlighted = false,
    bool loading = false,
  }) {
    final fg = highlighted ? AppColors.primary : AppColors.textSecondary;
    final bg = highlighted
        ? AppColors.primary.withValues(alpha: 0.12)
        : AppColors.grey100;
    final border = highlighted
        ? AppColors.primary.withValues(alpha: 0.35)
        : AppColors.grey200;

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Container(
          height: 40.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: border),
          ),
          child: loading
              ? SizedBox(
                  width: 18.w,
                  height: 18.w,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 14.sp, color: fg),
                    SizedBox(width: 5.w),
                    Flexible(
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w800,
                          color: fg,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildCheckoutPriceRow(
    String label,
    String value, {
    bool emphasized = false,
    Color? valueColor,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: emphasized ? 13.sp : 12.sp,
                fontWeight: emphasized ? FontWeight.w800 : FontWeight.w600,
                color: emphasized
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: emphasized ? 15.sp : 12.sp,
              fontWeight: emphasized ? FontWeight.w900 : FontWeight.w700,
              color: valueColor ??
                  (emphasized ? AppColors.primary : AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  /// Footer keranjang: hanya estimasi subtotal + lanjut ke halaman checkout.
  Widget _buildSimpleCartBar(
    BuildContext context,
    CartSummary cart,
    bool hasOutOfStock,
  ) {
    final selectedItems = cart.items
        .where((it) => _selectedItemIds.contains(it.id))
        .toList();
    final selectedTotal = selectedItems.fold<double>(
      0,
      (sum, it) => sum + (it.product.toEntity().pricePerUnit * it.quantity),
    );
    final selectedCount = selectedItems.length;
    final canContinue = selectedCount > 0 &&
        !_anySelectedOutOfStock(cart) &&
        !hasOutOfStock;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        minimum: EdgeInsets.only(bottom: AppSpacing.sm),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.sm10,
            AppSpacing.md,
            AppSpacing.sm,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      selectedCount > 0
                          ? 'cart.estimate_count'.tr(
                              namedArgs: {'count': '$selectedCount'},
                            )
                          : 'cart.pick_products'.tr(),
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      formatMoneyIdr(selectedTotal),
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      'cart.fees_at_checkout'.tr(),
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: AppColors.textHint,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: AppSpacing.md12),
              CustomButton(
                text: selectedCount == 0
                    ? 'cart.select'.tr()
                    : 'cart.checkout_count'.tr(
                        namedArgs: {'count': '$selectedCount'},
                      ),
                width: 148.w,
                height: 48.h,
                useGradient: canContinue,
                backgroundColor: canContinue ? null : AppColors.grey200,
                textColor:
                    canContinue ? AppColors.textOnPrimary : AppColors.textSecondary,
                onPressed:
                    canContinue ? () => _goToCheckoutPage(context, cart) : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckoutBar(
    BuildContext context,
    CartSummary cart,
    bool hasOutOfStock,
  ) {
    // Hitung subtotal dari item yang dipilih (bukan seluruh cart).
    final selectedItems = cart.items
        .where((it) => _selectedItemIds.contains(it.id))
        .toList();
    final selectedTotal = selectedItems.fold<double>(
      0,
      (sum, it) =>
          sum + (it.product.toEntity().pricePerUnit * it.quantity),
    );
    final selectedCount = selectedItems.length;
    final sellerIds = selectedItems
        .map((it) => it.product.toEntity().seller.id)
        .toSet();
    final shippingTotal = sellerIds.fold<double>(0, (sum, sellerId) {
      final selection = _shippingSelectionBySeller[sellerId];
      final cost = selection?['cost'];
      final value = cost is num
          ? cost.toDouble()
          : double.tryParse(cost?.toString() ?? '') ?? 0;
      return sum + value;
    });
    final hasCompleteShipping =
        selectedCount == 0 || sellerIds.every(_shippingSelectionBySeller.containsKey);
    double toDoubleValue(dynamic value) {
      if (value is num) return value.toDouble();
      return double.tryParse(value?.toString() ?? '') ?? 0;
    }

    final previewSubtotal = toDoubleValue(_checkoutPreview?['subtotal']);
    final previewVoucherDiscount =
        toDoubleValue(_checkoutPreview?['voucherDiscount']);
    final previewPlatformFee = toDoubleValue(_checkoutPreview?['platformFee']);
    final previewVat = toDoubleValue(_checkoutPreview?['vatAmount']);
    final previewLogistics = toDoubleValue(_checkoutPreview?['logisticsFee']);
    final previewTotal = toDoubleValue(_checkoutPreview?['totalAmount']);
    final hasPreview = _checkoutPreview != null;
    final isPreviewRefreshing =
        _checkoutPreviewLoading && _checkoutPreview != null;
    final subtotalShown =
        hasPreview ? previewSubtotal : selectedTotal;
    final logisticsShown = hasPreview ? previewLogistics : shippingTotal;
    final grandTotal = hasPreview
        ? previewTotal
        : (selectedTotal + shippingTotal);
    final shippingPayload = _checkoutShippingPayload();
    final hasValidShippingAddress =
        (shippingPayload.shippingAddress?.length ?? 0) >= 10;
    final isReadyToPlaceOrder =
        selectedCount > 0 &&
        !_isCheckingOut &&
        !_anySelectedOutOfStock(cart) &&
        hasCompleteShipping &&
        hasValidShippingAddress &&
        hasPreview &&
        _checkoutPreviewError == null &&
        !_checkoutPreviewLoading &&
        _selectedPayment != null;
    final canRetryPreview =
        !_isCheckingOut &&
        selectedCount > 0 &&
        hasCompleteShipping &&
        hasValidShippingAddress &&
        _checkoutPreviewError != null &&
        !_checkoutPreviewLoading;
    final canCheckout = isReadyToPlaceOrder || canRetryPreview;

    final checkoutButtonText = _isCheckingOut
        ? 'cart.processing'.tr()
        : (selectedCount == 0
            ? 'cart.select'.tr()
            : (hasOutOfStock && _anySelectedOutOfStock(cart)
                ? 'cart.remove_first'.tr()
                : (!hasValidShippingAddress
                      ? 'cart.complete_address'.tr()
                      : (_checkoutPreviewLoading
                            ? 'cart.calculating_short'.tr()
                            : (_checkoutPreviewError != null
                                  ? 'cart.retry'.tr()
                                  : (!hasCompleteShipping
                                        ? 'cart.setup_shipping_btn'.tr()
                                        : (!hasPreview
                                              ? 'cart.calculating_short'.tr()
                                              : (_selectedPayment == null
                                                    ? 'cart.pick_payment'.tr()
                                                    : 'cart.place_order'.tr()))))))));

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        minimum: EdgeInsets.only(bottom: AppSpacing.sm),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.sm10,
            AppSpacing.md,
            AppSpacing.sm,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedCount > 0
                        ? 'cart.summary_selected'.tr(
                            namedArgs: {'count': '$selectedCount'},
                          )
                        : 'cart.summary_payment'.tr(),
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    '${'cart.item_count'.tr(namedArgs: {'count': '${cart.count}'})}',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ),
              if (_isCheckoutFlow && selectedCount > 0) ...[
                SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _voucherCtrl,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: 'cart.voucher_hint'.tr(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                        ),
                        textCapitalization: TextCapitalization.characters,
                      ),
                    ),
                    SizedBox(width: AppSpacing.sm),
                    TextButton(
                      onPressed: _voucherApplying ? null : () => _applyVoucher(cart),
                      child: Text(
                        _appliedVoucherCode != null
                            ? 'cart.voucher_change'.tr()
                            : 'cart.voucher_apply'.tr(),
                      ),
                    ),
                  ],
                ),
                if (_voucherError != null)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _voucherError!,
                      style: TextStyle(fontSize: 11.sp, color: AppColors.error),
                    ),
                  ),
                if (_appliedVoucherCode != null)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'cart.voucher_applied'.tr(namedArgs: {
                        'code': _appliedVoucherCode!,
                      }),
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.success,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                if (_savedPaymentPref != null) ...[
                  SizedBox(height: 6.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'cart.saved_payment_hint'.tr(namedArgs: {
                        'name': _savedPaymentPref!.name,
                      }),
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
              SizedBox(height: AppSpacing.sm),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.md12,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: AppColors.grey50,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: AppColors.grey200),
                ),
                child: Column(
                  children: [
                    _buildCheckoutPriceRow(
                      'cart.subtotal'.tr(),
                      formatMoneyIdr(subtotalShown),
                    ),
                    if (hasPreview && previewVoucherDiscount > 0)
                      _buildCheckoutPriceRow(
                        'cart.voucher_discount'.tr(),
                        '-${formatMoneyIdr(previewVoucherDiscount)}',
                        valueColor: AppColors.success,
                      ),
                    if (hasPreview)
                      _buildCheckoutPriceRow(
                      'cart.fee_admin'.tr(),
                        formatMoneyIdr(previewPlatformFee),
                      ),
                    if (hasPreview)
                      _buildCheckoutPriceRow(
                        'cart.fee_vat'.tr(),
                        formatMoneyIdr(previewVat),
                      ),
                    _buildCheckoutPriceRow(
                      'cart.fee_shipping'.tr(),
                      formatMoneyIdr(logisticsShown),
                    ),
                  ],
                ),
              ),
              if (!hasValidShippingAddress && selectedCount > 0) ...[
                SizedBox(height: 6.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'cart.complete_shipping_address'.tr(),
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColors.warning,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
              if (!hasCompleteShipping && selectedCount > 0 && hasValidShippingAddress) ...[
                SizedBox(height: 6.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'cart.setup_all_shipping'.tr(),
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColors.warning,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
              if (_selectedPayment == null &&
                  selectedCount > 0 &&
                  hasValidShippingAddress &&
                  hasCompleteShipping &&
                  hasPreview &&
                  _checkoutPreviewError == null) ...[
                SizedBox(height: 6.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'cart.pick_payment_method'.tr(),
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColors.warning,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
              if (_checkoutPreviewLoading &&
                  selectedCount > 0 &&
                  hasCompleteShipping &&
                  !isPreviewRefreshing) ...[
                SizedBox(height: 6.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'cart.calculating_breakdown'.tr(),
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
              if (isPreviewRefreshing) ...[
                SizedBox(height: 6.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'cart.updating_breakdown'.tr(),
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
              if (_checkoutPreviewError != null && selectedCount > 0 && hasCompleteShipping) ...[
                SizedBox(height: 6.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _checkoutPreviewError!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColors.warning,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
              Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.sm10),
                child: Divider(height: 1.h, color: AppColors.grey300),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'cart.total'.tr(),
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          formatMoneyIdr(grandTotal),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary,
                          ),
                        ),
                        if (selectedCount > 0)
                          Text(
                            'cart.products_picked'.tr(
                              namedArgs: {'count': '$selectedCount'},
                            ),
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: AppColors.textHint,
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(width: AppSpacing.md12),
                  CustomButton(
                    text: checkoutButtonText,
                    width: 148.w,
                    size: BisaButtonSize.md,
                    fullWidth: false,
                    useGradient: canCheckout,
                    backgroundColor: canCheckout ? null : AppColors.grey200,
                    textColor: canCheckout
                        ? AppColors.textOnPrimary
                        : AppColors.textSecondary,
                    onPressed: isReadyToPlaceOrder
                        ? () => _onCheckout(context, cart)
                        : canRetryPreview
                            ? () {
                                _lastCheckoutPreviewKey = null;
                                _refreshCheckoutPreview(cart, force: true);
                              }
                            : null,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// True kalau ada item yang dicentang tapi stoknya 0.
  bool _anySelectedOutOfStock(CartSummary cart) {
    return cart.items.any(
      (it) =>
          _selectedItemIds.contains(it.id) &&
          it.product.toEntity().stock <= 0,
    );
  }

  Widget _qtyBtn(
    IconData icon, {
    required VoidCallback onTap,
    bool enabled = true,
  }) {
    final color = enabled ? AppColors.textPrimary : AppColors.grey300;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.button),
      child: Container(
        padding: EdgeInsets.all(6.r),
        decoration: BoxDecoration(
          border: Border.all(
            color: enabled ? AppColors.grey200 : AppColors.grey100,
          ),
          borderRadius: BorderRadius.circular(AppRadius.button),
          color: enabled ? AppColors.surface : AppColors.grey50,
        ),
        child: Icon(icon, size: 16.sp, color: color),
      ),
    );
  }
}

class _SellerGroup {
  final ProductSellerEntity seller;
  final List<CartItemModel> items;

  _SellerGroup({required this.seller, required this.items});
}

/// Section rekomendasi di halaman Keranjang — grid staggered 2 kolom
/// (`MasonryGridView`), konsisten dengan marketplace & favorit.
/// Memfilter produk berdasarkan `productMode` dominan di cart
/// (`BIOMASS_MATERIAL` ↔ `ORGANIC_PRODUCE`). Produk yang sudah ada
/// di cart (`excludeIds`) difilter client-side.
class _CartRecommendationSection extends StatefulWidget {
  final String productMode;
  final Set<String> excludeIds;

  const _CartRecommendationSection({
    required this.productMode,
    required this.excludeIds,
  });

  @override
  State<_CartRecommendationSection> createState() =>
      _CartRecommendationSectionState();
}

class _CartRecommendationSectionState
    extends State<_CartRecommendationSection> {
  late final MarketplaceCubit _cubit;

  /// True kalau hasil fetch by productMode kosong → coba lagi tanpa filter.
  bool _triedFallback = false;

  @override
  void initState() {
    super.initState();
    _cubit = sl<MarketplaceCubit>();
    _fetch();
  }

  @override
  void didUpdateWidget(covariant _CartRecommendationSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.productMode != widget.productMode) {
      _triedFallback = false;
      _fetch();
    }
  }

  void _fetch() {
    _cubit.getProducts(
      productMode: widget.productMode,
      sortBy: 'totalSold',
      sortOrder: 'desc',
      limit: 12,
    );
  }

  void _fetchFallback() {
    _triedFallback = true;
    _cubit.getProducts(
      sortBy: 'totalSold',
      sortOrder: 'desc',
      limit: 12,
    );
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  String _modeLabel(BuildContext context) =>
      widget.productMode == 'ORGANIC_PRODUCE'
          ? 'commerce.mode_organic'.tr()
          : 'commerce.mode_biomass'.tr();

  IconData get _modeIcon => widget.productMode == 'ORGANIC_PRODUCE'
      ? LucideIcons.sprout
      : LucideIcons.flame;

  Color get _modeColor => widget.productMode == 'ORGANIC_PRODUCE'
      ? AppColors.success
      : AppColors.warning;

  Widget _buildHeader(String subtitle) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(6.r),
          decoration: BoxDecoration(
            color: _modeColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
          child: Icon(_modeIcon, size: 14.sp, color: _modeColor),
        ),
        SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'cart.you_may_like'.tr(),
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => context.go('/'),
          child: Text(
            'commerce.see_all'.tr(),
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<MarketplaceCubit, MarketplaceState>(
        builder: (context, state) {
          return state.maybeWhen(
            initial: () => const SizedBox.shrink(),
            loading: () => Padding(
              padding: EdgeInsets.only(top: AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader('cart.rec_loading'.tr()),
                  SizedBox(height: AppSpacing.md12),
                  SizedBox(
                    height: ProductCardSkeleton.horizontalListViewportHeight,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      itemCount: 3,
                      separatorBuilder: (_, __) => SizedBox(width: AppSpacing.md12),
                      itemBuilder: (_, __) => SizedBox(
                        width: 160.w,
                        child: ProductCardSkeleton(
                          imageHeight: 120.h,
                          showSellerInfo: true,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            error: (msg) => Padding(
              padding: EdgeInsets.only(top: AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader('cart.rec_failed'.tr()),
                  SizedBox(height: AppSpacing.sm),
                  Container(
                    padding: EdgeInsets.all(AppSpacing.md12),
                    decoration: BoxDecoration(
                      color: AppColors.grey50,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          LucideIcons.wifiOff,
                          color: AppColors.textHint,
                          size: 16.sp,
                        ),
                        SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            msg,
                            style: AppTextStyles.bodySecondary(color: AppColors.textSecondary),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            _triedFallback = false;
                            _fetch();
                          },
                          child: Text('coba_lagi'.tr()),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            loaded: (products, _) {
              final filtered = products
                  .where((p) => !widget.excludeIds.contains(p.id))
                  .toList();

              // Fallback: kalau filter per-mode hasilnya kosong, fetch ulang
              // tanpa filter mode (top selling overall).
              if (filtered.isEmpty && !_triedFallback) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) _fetchFallback();
                });
                return Padding(
                  padding: EdgeInsets.only(top: AppSpacing.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader('cart.rec_searching'.tr()),
                      SizedBox(height: AppSpacing.md12),
                      SizedBox(
                        height: 120.h,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                          itemCount: 2,
                          separatorBuilder: (_, __) => SizedBox(width: AppSpacing.md12),
                          itemBuilder: (_, __) => SizedBox(
                            width: 140.w,
                            child: ProductCardSkeleton(
                              imageHeight: 52.h,
                              showSellerInfo: false,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (filtered.isEmpty) {
                // Bahkan setelah fallback masih kosong → tampilkan empty state
                return Padding(
                  padding: EdgeInsets.only(top: AppSpacing.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader('cart.rec_none'.tr()),
                      SizedBox(height: AppSpacing.sm10),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.section,
                          vertical: 18.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.grey50,
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              LucideIcons.packageSearch,
                              color: AppColors.grey400,
                              size: 28.sp,
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              'cart.explore_marketplace'.tr(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: AppSpacing.sm),
                            TextButton.icon(
                              onPressed: () => context.go('/'),
                              icon: Icon(
                                LucideIcons.store,
                                size: 14.sp,
                                color: AppColors.primary,
                              ),
                              label: Text(
                                'cart.open_marketplace'.tr(),
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }

              final subtitle = _triedFallback
                  ? 'cart.rec_bestseller'.tr()
                  : 'cart.rec_mode_bestseller'.tr(
                      namedArgs: {'mode': _modeLabel(context)},
                    );

              return Padding(
                padding: EdgeInsets.only(top: AppSpacing.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(subtitle),
                    SizedBox(height: AppSpacing.md12),
                    MasonryGridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: AppSpacing.md12,
                      crossAxisSpacing: AppSpacing.sm10,
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        return ProductCard(product: filtered[index]);
                      },
                    ),
                  ],
                ),
              );
            },
            orElse: () => const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}
