import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../menu/data/models/menu_item_model.dart';
import '../models/category_model.dart';

abstract class CategoryRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
  Future<List<MenuItemModel>> getCategoryItems(String categoryId);
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final Dio dio;
  const CategoryRemoteDataSourceImpl(this.dio);

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await dio.get(ApiConstants.categories);
      final List list = response.data['categories'];
      return list.map((json) => CategoryModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(_extractMessage(e));
    }
  }

  @override
  Future<List<MenuItemModel>> getCategoryItems(String categoryId) async {
    try {
      final response = await dio.get(ApiConstants.categoryItems(categoryId));
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
