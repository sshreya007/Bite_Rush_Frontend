import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart' show dioClientProvider;
import '../../data/datasources/order_remote_datasource.dart';
import '../../data/repositories/order_repository_impl.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_repository.dart';
import '../../domain/usecases/place_order.dart';
import '../../domain/usecases/get_order_status.dart';
import '../../domain/usecases/get_my_orders.dart';
import '../../../../core/usecase/usecase.dart';

final orderRemoteDataSourceProvider = Provider<OrderRemoteDataSource>((ref) {
  return OrderRemoteDataSourceImpl(ref.read(dioClientProvider));
});

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepositoryImpl(ref.read(orderRemoteDataSourceProvider));
});

final placeOrderProvider = Provider<PlaceOrder>((ref) {
  return PlaceOrder(ref.read(orderRepositoryProvider));
});

final getOrderStatusProvider = Provider<GetOrderStatus>((ref) {
  return GetOrderStatus(ref.read(orderRepositoryProvider));
});

final getMyOrdersProvider = Provider<GetMyOrders>((ref) {
  return GetMyOrders(ref.read(orderRepositoryProvider));
});

final orderHistoryProvider = FutureProvider<List<OrderEntity>>((ref) async {
  final result = await ref.read(getMyOrdersProvider)(const NoParams());
  return result.fold((failure) => throw failure.message, (orders) => orders);
});

/// Tracks the current checkout submission — idle/loading/success/error,
/// so CheckoutPage can show a spinner and disable the button while
/// the order is being placed.
class CheckoutState {
  final bool isLoading;
  final OrderEntity? placedOrder;
  final String? errorMessage;

  const CheckoutState({this.isLoading = false, this.placedOrder, this.errorMessage});

  CheckoutState copyWith({bool? isLoading, OrderEntity? placedOrder, String? errorMessage}) {
    return CheckoutState(
      isLoading: isLoading ?? this.isLoading,
      placedOrder: placedOrder ?? this.placedOrder,
      errorMessage: errorMessage,
    );
  }
}

class CheckoutNotifier extends StateNotifier<CheckoutState> {
  final PlaceOrder _placeOrder;
  CheckoutNotifier(this._placeOrder) : super(const CheckoutState());

  Future<bool> submit(PlaceOrderParams params) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await _placeOrder(params);
    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
        return false;
      },
      (order) {
        state = state.copyWith(isLoading: false, placedOrder: order, errorMessage: null);
        return true;
      },
    );
  }
}

final checkoutNotifierProvider = StateNotifierProvider<CheckoutNotifier, CheckoutState>((ref) {
  return CheckoutNotifier(ref.read(placeOrderProvider));
});
