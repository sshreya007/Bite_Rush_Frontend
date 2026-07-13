import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../menu/data/models/menu_item_model.dart';
import '../models/restaurant_model.dart';

abstract class RestaurantRemoteDataSource {
  Future<List<RestaurantModel>> getRestaurants();
  Future<RestaurantModel> getRestaurantById(String id);
  Future<List<MenuItemModel>> getRestaurantMenu(String restaurantId);
}

class RestaurantRemoteDataSourceImpl implements RestaurantRemoteDataSource {
  final Dio dio;
  const RestaurantRemoteDataSourceImpl(this.dio);

  @override
  Future<List<RestaurantModel>> getRestaurants() async {
    try {
      final response = await dio.get(ApiConstants.restaurants);
      final List list = response.data['restaurants'];
      return list.map((json) => RestaurantModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(_extractMessage(e));
    }
  }

  @override
  Future<RestaurantModel> getRestaurantById(String id) async {
    try {
      final response = await dio.get(ApiConstants.restaurantById(id));
      return RestaurantModel.fromJson(response.data['restaurant']);
    } on DioException catch (e) {
      throw ServerException(_extractMessage(e));
    }
  }

  @override
  Future<List<MenuItemModel>> getRestaurantMenu(String restaurantId) async {
    try {
      final response = await dio.get(ApiConstants.restaurantMenu(restaurantId));
      final List list = response.data['items'];
      return list.map((json) => MenuItemModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(_extractMessage(e));
    }
  }

  String _extractMessage(DioException e) {
    if (e.response?.data is Map && e.response?.data['message'] != null) {
      return e.response!.data['message'];
    }
    return 'Could not load data. Check your connection.';
  }
}
