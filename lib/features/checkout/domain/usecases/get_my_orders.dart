import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';

class GetMyOrders implements UseCase<List<OrderEntity>, NoParams> {
  final OrderRepository repository;
  const GetMyOrders(this.repository);

  @override
  Future<Either<Failure, List<OrderEntity>>> call(NoParams params) {
    return repository.getMyOrders();
  }
}
