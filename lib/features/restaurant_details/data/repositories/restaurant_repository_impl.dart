import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../menu/domain/entities/menu_item_entity.dart';
import '../../domain/entities/restaurant_entity.dart';
import '../../domain/repositories/restaurant_repository.dart';
import '../datasources/restaurant_remote_datasource.dart';

class RestaurantRepositoryImpl implements RestaurantRepository {
  final RestaurantRemoteDataSource remoteDataSource;
  const RestaurantRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<RestaurantEntity>>> getRestaurants() async {
    try {
      final restaurants = await remoteDataSource.getRestaurants();
      return Right(restaurants);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, RestaurantEntity>> getRestaurantById(String id) async {
    try {
      final restaurant = await remoteDataSource.getRestaurantById(id);
      return Right(restaurant);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MenuItemEntity>>> getRestaurantMenu(String restaurantId) async {
    try {
      final items = await remoteDataSource.getRestaurantMenu(restaurantId);
      return Right(items);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
