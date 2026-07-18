import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class UpdateProfile implements UseCase<UserEntity, UpdateProfileParams> {
  final AuthRepository repository;
  const UpdateProfile(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(UpdateProfileParams params) {
    return repository.updateProfile(name: params.name, phone: params.phone);
  }
}

class UpdateProfileParams extends Equatable {
  final String? name;
  final String? phone;
  const UpdateProfileParams({this.name, this.phone});

  @override
  List<Object?> get props => [name, phone];
}
