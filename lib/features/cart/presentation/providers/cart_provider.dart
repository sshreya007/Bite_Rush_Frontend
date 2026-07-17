import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/cart_item_entity.dart';

/// Cart lives entirely in app memory until checkout — there's no
/// backend "Cart" model. At checkout, the current cart lines are
/// sent to POST /api/orders as a snapshot, then the cart is cleared.
class CartNotifier extends StateNotifier<List<CartItemEntity>> {
  CartNotifier() : super([]);

  void addItem({
    required String menuItemId,
    required String name,
    required double price,
    required String image,
    required int quantity,
    List<String> addons = const [],
    String specialInstruction = '',
  }) {
    // Same menu item + same addons + same instructions = bump quantity
    // on the existing line instead of adding a duplicate row.
    final existingIndex = state.indexWhere((item) =>
        item.menuItemId == menuItemId &&
        _sameAddons(item.addons, addons) &&
        item.specialInstruction == specialInstruction);

    if (existingIndex != -1) {
      final existing = state[existingIndex];
      state = [
        for (int i = 0; i < state.length; i++)
          if (i == existingIndex) existing.copyWith(quantity: existing.quantity + quantity) else state[i],
      ];
      return;
    }

    state = [
      ...state,
      CartItemEntity(
        cartLineId: DateTime.now().microsecondsSinceEpoch.toString(),
        menuItemId: menuItemId,
        name: name,
        price: price,
        image: image,
        quantity: quantity,
        addons: addons,
        specialInstruction: specialInstruction,
      ),
    ];
  }

  bool _sameAddons(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    final sortedA = [...a]..sort();
    final sortedB = [...b]..sort();
    for (int i = 0; i < sortedA.length; i++) {
      if (sortedA[i] != sortedB[i]) return false;
    }
    return true;
  }

  void updateQuantity(String cartLineId, int newQuantity) {
    if (newQuantity <= 0) {
      removeItem(cartLineId);
      return;
    }
    state = [
      for (final item in state)
        if (item.cartLineId == cartLineId) item.copyWith(quantity: newQuantity) else item,
    ];
  }

  void removeItem(String cartLineId) {
    state = state.where((item) => item.cartLineId != cartLineId).toList();
  }

  void clear() {
    state = [];
  }

  double get total => state.fold(0, (sum, item) => sum + item.subtotal);
  int get itemCount => state.fold(0, (sum, item) => sum + item.quantity);
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItemEntity>>((ref) {
  return CartNotifier();
});
