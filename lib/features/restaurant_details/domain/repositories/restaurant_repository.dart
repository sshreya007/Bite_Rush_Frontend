import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../menu/domain/entities/menu_item_entity.dart';
import '../entities/restaurant_entity.dart';

abstract class RestaurantRepository {
  Future<Either<Failure, List<RestaurantEntity>>> getRestaurants();
  Future<Either<Failure, RestaurantEntity>> getRestaurantById(String id);
  Future<Either<Failure, List<MenuItemEntity>>> getRestaurantMenu(String restaurantId);
}
