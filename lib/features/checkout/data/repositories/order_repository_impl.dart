import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../cart/domain/entities/cart_item_entity.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_remote_datasource.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;
  const OrderRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, OrderEntity>> placeOrder({
    required List<CartItemEntity> items,
    required String deliveryAddress,
    required String paymentMethod,
  }) async {
    try {
      final order = await remoteDataSource.placeOrder(
        items: items,
        deliveryAddress: deliveryAddress,
        paymentMethod: paymentMethod,
      );
      return Right(order);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> getOrderById(String id) async {
    try {
      final order = await remoteDataSource.getOrderById(id);
      return Right(order);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getMyOrders() async {
    try {
      final orders = await remoteDataSource.getMyOrders();
      return Right(orders);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
