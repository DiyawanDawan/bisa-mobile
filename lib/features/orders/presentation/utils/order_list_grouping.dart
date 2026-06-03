import 'package:intl/intl.dart';
import '../../domain/entities/order_entity.dart';

/// Satu kluster checkout (beberapa pesanan dibuat bersamaan).
class OrderCheckoutCluster {
  final List<OrderEntity> orders;

  const OrderCheckoutCluster(this.orders);

  int get length => orders.length;
  bool get isMulti => orders.length > 1;

  double get totalAmount =>
      orders.fold<double>(0, (sum, o) => sum + o.totalAmount);

  /// Nomor pesanan gabungan yang ditampilkan ke buyer.
  String? get checkoutBatchNumber {
    if (orders.isEmpty) return null;
    final first = orders.first.displayOrderNumber;
    if (orders.every((o) => o.displayOrderNumber == first)) {
      return first;
    }
    return null;
  }

  /// Status tunggal untuk seluruh batch (tahap paling awal jika berbeda).
  String get aggregateStatus {
    if (orders.isEmpty) return 'PENDING';
    const pipeline = [
      'PENDING',
      'CONFIRMED',
      'PROCESSING',
      'PAID',
      'SHIPPED',
      'COMPLETED',
      'DISPUTED',
      'REFUNDED',
      'CANCELLED',
    ];
    final statuses = orders.map((o) => o.status.toUpperCase()).toSet();
    if (statuses.length == 1) return statuses.first;
    for (final step in pipeline) {
      if (statuses.contains(step)) return step;
    }
    return orders.first.status.toUpperCase();
  }

  OrderEntity get leadOrder {
    final copy = List<OrderEntity>.from(orders)
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return copy.first;
  }

  DateTime get sortDate {
    if (orders.isEmpty) return DateTime.now();
    return orders.map((o) => o.createdAt).reduce((a, b) => a.isAfter(b) ? a : b);
  }

  /// Semua baris produk dari seluruh supplier dalam batch.
  List<BatchProductLine> get productLines {
    final lines = <BatchProductLine>[];
    for (final order in orders) {
      for (final item in order.items) {
        lines.add(BatchProductLine(order: order, item: item));
      }
    }
    return lines;
  }

  int get totalItemCount => productLines.length;
}

/// Satu produk dalam checkout multi-supplier (untuk tampilan list).
class BatchProductLine {
  const BatchProductLine({required this.order, required this.item});

  final OrderEntity order;
  final OrderItemEntity item;
}

/// Grup pesanan berdasarkan prefix nomor order (mis. ORD-20260302).
class OrderNumberGroup {
  final String groupKey;
  final DateTime sortDate;
  final List<OrderCheckoutCluster> clusters;

  const OrderNumberGroup({
    required this.groupKey,
    required this.sortDate,
    required this.clusters,
  });

  int get orderCount =>
      clusters.fold<int>(0, (sum, c) => sum + c.orders.length);

  /// Untuk tampilan buyer: batch multi-supplier dihitung 1 pesanan.
  int get displayOrderCount =>
      clusters.fold<int>(0, (sum, c) => sum + (c.isMulti ? 1 : c.length));
}

/// Prefix nomor order untuk pengelompokan (tanggal batch).
String orderGroupKeyFromNumber(String orderNumber) {
  final trimmed = orderNumber.trim();
  final parts = trimmed.split('-');
  if (parts.length >= 3 && (parts[0] == 'ORD' || parts[0] == 'B2B')) {
    // ORD-BISA-MCHK-YYYYMMDD-...
    if (parts.length >= 5 &&
        parts[1] == 'BISA' &&
        parts[2] == 'MCHK' &&
        RegExp(r'^\d{8}$').hasMatch(parts[3])) {
      return '${parts[0]}-BISA-MCHK-${parts[3]}';
    }
    // ORD-BATCH-YYYYMMDD-... (data lama)
    if (parts.length >= 4 &&
        parts[1] == 'BATCH' &&
        RegExp(r'^\d{8}$').hasMatch(parts[2])) {
      return '${parts[0]}-BATCH-${parts[2]}';
    }
    final datePart = parts[1];
    if (RegExp(r'^\d{8}$').hasMatch(datePart)) {
      return '${parts[0]}-$datePart';
    }
  }
  return trimmed;
}

String _orderGroupKey(OrderEntity order) {
  final batch = order.checkoutBatchNumber?.trim();
  if (batch != null && batch.isNotEmpty) {
    return orderGroupKeyFromNumber(batch);
  }
  return orderGroupKeyFromNumber(order.orderNumber);
}

DateTime? dateFromOrderGroupKey(String groupKey) {
  final match = RegExp(r'^(ORD|B2B)-(\d{8})$').firstMatch(groupKey.trim());
  if (match == null) return null;
  final raw = match.group(2)!;
  return DateTime.tryParse(
    '${raw.substring(0, 4)}-${raw.substring(4, 6)}-${raw.substring(6, 8)}',
  );
}

String orderGroupTitle(String groupKey, {DateTime? fallbackDate}) {
  final parsed = dateFromOrderGroupKey(groupKey) ?? fallbackDate;
  if (parsed != null) {
    return DateFormat('d MMMM yyyy', 'id_ID').format(parsed);
  }
  return groupKey;
}

const _checkoutClusterGap = Duration(minutes: 3);

String? _batchClusterKey(OrderEntity order) {
  final batchId = order.checkoutBatchId?.trim();
  if (batchId != null && batchId.isNotEmpty) return 'id:$batchId';

  final batchNo = order.checkoutBatchNumber?.trim();
  if (batchNo != null && batchNo.isNotEmpty) return 'no:$batchNo';

  return null;
}

List<OrderCheckoutCluster> _buildClusters(List<OrderEntity> sorted) {
  if (sorted.isEmpty) return const [];

  final usedIds = <String>{};
  final clusters = <OrderCheckoutCluster>[];

  // Kluster eksplisit: pesanan dengan checkoutBatchId / checkoutBatchNumber sama.
  final batchGroups = <String, List<OrderEntity>>{};
  for (final order in sorted) {
    final key = _batchClusterKey(order);
    if (key == null) continue;
    batchGroups.putIfAbsent(key, () => []).add(order);
  }

  for (final entry in batchGroups.entries) {
    if (entry.value.length < 2) continue;
    final clusterOrders = List<OrderEntity>.from(entry.value)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    clusters.add(OrderCheckoutCluster(clusterOrders));
    usedIds.addAll(clusterOrders.map((o) => o.id));
  }

  for (final order in sorted) {
    if (usedIds.contains(order.id)) continue;

    if (clusters.isEmpty) {
      clusters.add(OrderCheckoutCluster([order]));
      usedIds.add(order.id);
      continue;
    }

    final lastCluster = clusters.last;
    if (lastCluster.isMulti) {
      clusters.add(OrderCheckoutCluster([order]));
      usedIds.add(order.id);
      continue;
    }

    final anchor = lastCluster.orders.first.createdAt;
    if (anchor.difference(order.createdAt).abs() <= _checkoutClusterGap) {
      lastCluster.orders.add(order);
      lastCluster.orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } else {
      clusters.add(OrderCheckoutCluster([order]));
    }
    usedIds.add(order.id);
  }

  clusters.sort(
    (a, b) => b.orders.first.createdAt.compareTo(a.orders.first.createdAt),
  );
  return clusters;
}

List<OrderNumberGroup> groupOrdersByOrderNumber(List<OrderEntity> orders) {
  if (orders.isEmpty) return const [];

  final byKey = <String, List<OrderEntity>>{};
  for (final order in orders) {
    final key = _orderGroupKey(order);
    byKey.putIfAbsent(key, () => []).add(order);
  }

  final groups = <OrderNumberGroup>[];
  for (final entry in byKey.entries) {
    final sorted = List<OrderEntity>.from(entry.value)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    groups.add(
      OrderNumberGroup(
        groupKey: entry.key,
        sortDate: sorted.first.createdAt,
        clusters: _buildClusters(sorted),
      ),
    );
  }

  groups.sort((a, b) => b.sortDate.compareTo(a.sortDate));
  return groups;
}
