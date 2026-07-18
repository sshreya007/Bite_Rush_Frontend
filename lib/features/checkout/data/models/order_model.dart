import '../../domain/entities/order_entity.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.totalAmount,
    required super.status,
    required super.deliveryAddress,
    super.items,
    super.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final List rawItems = json['items'] ?? [];
    return OrderModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0,
      status: json['status'] ?? 'Placed',
      deliveryAddress: json['deliveryAddress'] ?? '',
      items: rawItems
          .map((item) => OrderItemSummary(
                name: item['name'] ?? '',
                price: (item['price'] as num?)?.toDouble() ?? 0,
                quantity: (item['quantity'] as num?)?.toInt() ?? 1,
              ))
          .toList(),
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
    );
  }
}
