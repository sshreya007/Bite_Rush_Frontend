import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart' show dioClientProvider;
import '../../data/datasources/restaurant_remote_datasource.dart';
import '../../data/repositories/restaurant_repository_impl.dart';
import '../../domain/entities/restaurant_entity.dart';
import '../../domain/repositories/restaurant_repository.dart';
import '../../domain/usecases/get_restaurants.dart';
import '../../domain/usecases/get_restaurant_menu.dart';
import '../../../menu/domain/entities/menu_item_entity.dart';
import '../../../../core/usecase/usecase.dart';

final restaurantRemoteDataSourceProvider = Provider<RestaurantRemoteDataSource>((ref) {
  return RestaurantRemoteDataSourceImpl(ref.read(dioClientProvider));
});

final restaurantRepositoryProvider = Provider<RestaurantRepository>((ref) {
  return RestaurantRepositoryImpl(ref.read(restaurantRemoteDataSourceProvider));
});

final getRestaurantsProvider = Provider<GetRestaurants>((ref) {
  return GetRestaurants(ref.read(restaurantRepositoryProvider));
});

final getRestaurantMenuProvider = Provider<GetRestaurantMenu>((ref) {
  return GetRestaurantMenu(ref.read(restaurantRepositoryProvider));
});

final restaurantsListProvider = FutureProvider<List<RestaurantEntity>>((ref) async {
  final result = await ref.read(getRestaurantsProvider)(const NoParams());
  return result.fold((failure) => throw failure.message, (restaurants) => restaurants);
});

final restaurantMenuProvider =
    FutureProvider.family<List<MenuItemEntity>, String>((ref, restaurantId) async {
  final result = await ref.read(getRestaurantMenuProvider)(restaurantId);
  return result.fold((failure) => throw failure.message, (items) => items);
});
