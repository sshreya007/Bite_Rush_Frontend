import 'package:equatable/equatable.dart';

/// Pure domain representation of a user. No JSON, no Mongo _id string
/// quirks — that translation happens in the data layer's UserModel.
class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
  });

  @override
  List<Object?> get props => [id, name, email, phone];
}
