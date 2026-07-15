import 'package:equatable/equatable.dart';

class OfferEntity extends Equatable {
  final String id;
  final String title;
  final String image;
  final int discountPercent;
  final String restaurantId;
  final String restaurantName;

  const OfferEntity({
    required this.id,
    required this.title,
    required this.image,
    this.discountPercent = 0,
    this.restaurantId = '',
    this.restaurantName = '',
  });

  @override
  List<Object?> get props => [id, title, image, discountPercent];
}
