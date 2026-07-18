import 'package:equatable/equatable.dart';

class OrderEntity extends Equatable {
  final String id;
  final double totalAmount;
  final String status;
  final String deliveryAddress;
  final List<OrderItemSummary> items;
  final DateTime? createdAt;

  const OrderEntity({
    required this.id,
    required this.totalAmount,
    required this.status,
    required this.deliveryAddress,
    this.items = const [],
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, status];
}

/// Lightweight snapshot of what was ordered — enough to display in
/// Order History without needing to re-fetch the original menu items.
class OrderItemSummary extends Equatable {
  final String name;
  final double price;
  final int quantity;

  const OrderItemSummary({required this.name, required this.price, required this.quantity});

  @override
  List<Object?> get props => [name, price, quantity];
}
