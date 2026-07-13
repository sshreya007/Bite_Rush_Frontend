import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/restaurant_entity.dart';
import '../repositories/restaurant_repository.dart';

class GetRestaurants implements UseCase<List<RestaurantEntity>, NoParams> {
  final RestaurantRepository repository;
  const GetRestaurants(this.repository);

  @override
  Future<Either<Failure, List<RestaurantEntity>>> call(NoParams params) {
    return repository.getRestaurants();
  }
}
