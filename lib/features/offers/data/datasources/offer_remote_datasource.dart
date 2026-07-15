import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/offer_model.dart';

abstract class OfferRemoteDataSource {
  Future<List<OfferModel>> getOffers();
}

class OfferRemoteDataSourceImpl implements OfferRemoteDataSource {
  final Dio dio;
  const OfferRemoteDataSourceImpl(this.dio);

  @override
  Future<List<OfferModel>> getOffers() async {
    try {
      final response = await dio.get(ApiConstants.offers);
      final List list = response.data['offers'];
      return list.map((json) => OfferModel.fromJson(json)).toList();
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
