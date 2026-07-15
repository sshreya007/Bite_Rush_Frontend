import '../../domain/entities/offer_entity.dart';

class OfferModel extends OfferEntity {
  const OfferModel({
    required super.id,
    required super.title,
    required super.image,
    super.discountPercent,
    super.restaurantId,
    super.restaurantName,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    final restaurant = json['restaurant'];
    return OfferModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      image: json['image'] ?? '',
      discountPercent: (json['discountPercent'] as num?)?.toInt() ?? 0,
      restaurantId: restaurant is Map ? (restaurant['_id']?.toString() ?? '') : (restaurant?.toString() ?? ''),
      restaurantName: restaurant is Map ? (restaurant['name'] ?? '') : '',
    );
  }
}
