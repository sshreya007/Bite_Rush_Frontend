import 'package:equatable/equatable.dart';

/// Represents a single food item. Shared between "items in this
/// category" (across restaurants) and "menu of this restaurant"
/// (across categories) — same shape, different filter context.
class MenuItemEntity extends Equatable {
  final String id;
  final String name;
  final double price;
  final String image;
  final String description;
  final String restaurantId;
  final String restaurantName; // handy when showing category-item lists
  final String categoryId;
  final String categoryName; // handy when showing a restaurant's menu

  const MenuItemEntity({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    this.description = '',
    required this.restaurantId,
    this.restaurantName = '',
    required this.categoryId,
    this.categoryName = '',
  });

  @override
  List<Object?> get props => [id, name, price, image, restaurantId, categoryId];
}
