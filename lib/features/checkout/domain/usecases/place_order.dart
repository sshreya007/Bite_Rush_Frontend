import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../cart/domain/entities/cart_item_entity.dart';
import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';

class PlaceOrder implements UseCase<OrderEntity, PlaceOrderParams> {
  final OrderRepository repository;
  const PlaceOrder(this.repository);

  @override
  Future<Either<Failure, OrderEntity>> call(PlaceOrderParams params) {
    return repository.placeOrder(
      items: params.items,
      deliveryAddress: params.deliveryAddress,
      paymentMethod: params.paymentMethod,
    );
  }
}

class PlaceOrderParams extends Equatable {
  final List<CartItemEntity> items;
  final String deliveryAddress;
  final String paymentMethod;

  const PlaceOrderParams({
    required this.items,
    required this.deliveryAddress,
    this.paymentMethod = 'Cash',
  });

  @override
  List<Object?> get props => [items, deliveryAddress, paymentMethod];
}
