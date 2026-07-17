import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../cart/domain/entities/cart_item_entity.dart';
import '../models/order_model.dart';

abstract class OrderRemoteDataSource {
  Future<OrderModel> placeOrder({
    required List<CartItemEntity> items,
    required String deliveryAddress,
    required String paymentMethod,
  });

  Future<OrderModel> getOrderById(String id);
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final Dio dio;
  const OrderRemoteDataSourceImpl(this.dio);

  @override
  Future<OrderModel> placeOrder({
    required List<CartItemEntity> items,
    required String deliveryAddress,
    required String paymentMethod,
  }) async {
    try {
      final response = await dio.post(
        ApiConstants.orders,
        data: {
          'items': items
              .map((item) => {
                    'menuItem': item.menuItemId,
                    'name': item.name,
                    'price': item.price,
                    'quantity': item.quantity,
                    'addons': item.addons,
                    'specialInstruction': item.specialInstruction,
                  })
              .toList(),
          'deliveryAddress': deliveryAddress,
          'paymentMethod': paymentMethod,
        },
      );
      return OrderModel.fromJson(response.data['order']);
    } on DioException catch (e) {
      throw ServerException(_extractMessage(e));
    }
  }

  @override
  Future<OrderModel> getOrderById(String id) async {
    try {
      final response = await dio.get(ApiConstants.orderById(id));
      return OrderModel.fromJson(response.data['order']);
    } on DioException catch (e) {
      throw ServerException(_extractMessage(e));
    }
  }

  String _extractMessage(DioException e) {
    if (e.response?.data is Map && e.response?.data['message'] != null) {
      return e.response!.data['message'];
    }
    return 'Could not place order. Check your connection.';
  }
}
