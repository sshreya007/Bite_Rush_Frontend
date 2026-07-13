import '../../domain/entities/restaurant_entity.dart';

class RestaurantModel extends RestaurantEntity {
  const RestaurantModel({
    required super.id,
    required super.name,
    required super.image,
    super.banner,
    super.description,
    super.address,
    super.phone,
    super.cuisine,
    super.rating,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      banner: json['banner'] ?? '',
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      cuisine: json['cuisine'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
    );
  }
}
