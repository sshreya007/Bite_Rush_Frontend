import 'package:equatable/equatable.dart';

class OrderEntity extends Equatable {
  final String id;
  final double totalAmount;
  final String status;
  final String deliveryAddress;

  const OrderEntity({
    required this.id,
    required this.totalAmount,
    required this.status,
    required this.deliveryAddress,
  });

  @override
  List<Object?> get props => [id, status];
}
