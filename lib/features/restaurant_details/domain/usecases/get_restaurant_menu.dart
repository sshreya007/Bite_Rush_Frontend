import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../menu/domain/entities/menu_item_entity.dart';
import '../repositories/restaurant_repository.dart';

class GetRestaurantMenu implements UseCase<List<MenuItemEntity>, String> {
  final RestaurantRepository repository;
  const GetRestaurantMenu(this.repository);

  @override
  Future<Either<Failure, List<MenuItemEntity>>> call(String restaurantId) {
    return repository.getRestaurantMenu(restaurantId);
  }
}
