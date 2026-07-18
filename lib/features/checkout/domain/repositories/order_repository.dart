import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../cart/domain/entities/cart_item_entity.dart';
import '../entities/order_entity.dart';

abstract class OrderRepository {
  Future<Either<Failure, OrderEntity>> placeOrder({
    required List<CartItemEntity> items,
    required String deliveryAddress,
    required String paymentMethod,
  });

  Future<Either<Failure, OrderEntity>> getOrderById(String id);

  Future<Either<Failure, List<OrderEntity>>> getMyOrders();
}
