import 'package:equatable/equatable.dart';

class RestaurantEntity extends Equatable {
  final String id;
  final String name;
  final String image;
  final String banner;
  final String description;
  final String address;
  final String phone;
  final String cuisine;
  final double rating;

  const RestaurantEntity({
    required this.id,
    required this.name,
    required this.image,
    this.banner = '',
    this.description = '',
    this.address = '',
    this.phone = '',
    this.cuisine = '',
    this.rating = 0,
  });

  @override
  List<Object?> get props => [id, name, image];
}
