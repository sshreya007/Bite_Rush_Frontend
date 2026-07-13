import '../../domain/entities/menu_item_entity.dart';

class MenuItemModel extends MenuItemEntity {
  const MenuItemModel({
    required super.id,
    required super.name,
    required super.price,
    required super.image,
    super.description,
    required super.restaurantId,
    super.restaurantName,
    required super.categoryId,
    super.categoryName,
  });

  /// Handles the backend's populate() shape, where `restaurant` or
  /// `category` may come back as either a plain ID string or a
  /// populated object like { _id, name }.
  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    final restaurant = json['restaurant'];
    final category = json['category'];

    return MenuItemModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      image: json['image'] ?? '',
      description: json['description'] ?? '',
      restaurantId: restaurant is Map ? (restaurant['_id']?.toString() ?? '') : (restaurant?.toString() ?? ''),
      restaurantName: restaurant is Map ? (restaurant['name'] ?? '') : '',
      categoryId: category is Map ? (category['_id']?.toString() ?? '') : (category?.toString() ?? ''),
      categoryName: category is Map ? (category['name'] ?? '') : '',
    );
  }
}
