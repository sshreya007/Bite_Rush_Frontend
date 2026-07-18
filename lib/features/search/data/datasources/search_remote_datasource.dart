import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../menu/data/models/menu_item_model.dart';

abstract class SearchRemoteDataSource {
  Future<List<MenuItemModel>> search(String query);
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final Dio dio;
  const SearchRemoteDataSourceImpl(this.dio);

  @override
  Future<List<MenuItemModel>> search(String query) async {
    try {
      final response = await dio.get(ApiConstants.search, queryParameters: {'q': query});
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
    return 'Search failed. Check your connection.';
  }
}
