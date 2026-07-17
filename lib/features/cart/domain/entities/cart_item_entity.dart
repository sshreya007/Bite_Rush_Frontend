import 'package:equatable/equatable.dart';

/// A single line in the cart. Distinct from MenuItemEntity because
/// the same food item can appear as two separate cart lines if
/// customized differently (e.g. one with cheese, one without) —
/// so cart lines get their own unique id.
class CartItemEntity extends Equatable {
  final String cartLineId; // unique per customization, not per menu item
  final String menuItemId;
  final String name;
  final double price;
  final String image;
  final int quantity;
  final List<String> addons;
  final String specialInstruction;

  const CartItemEntity({
    required this.cartLineId,
    required this.menuItemId,
    required this.name,
    required this.price,
    required this.image,
    required this.quantity,
    this.addons = const [],
    this.specialInstruction = '',
  });

  double get subtotal => price * quantity;

  CartItemEntity copyWith({int? quantity}) {
    return CartItemEntity(
      cartLineId: cartLineId,
      menuItemId: menuItemId,
      name: name,
      price: price,
      image: image,
      quantity: quantity ?? this.quantity,
      addons: addons,
      specialInstruction: specialInstruction,
    );
  }

  @override
  List<Object?> get props => [cartLineId, quantity];
}
