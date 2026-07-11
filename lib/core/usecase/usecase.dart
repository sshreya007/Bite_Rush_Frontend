import 'package:dartz/dartz.dart';
import '../error/failures.dart';

/// Every usecase implements this: takes Params, returns Either a
/// Failure or a Type. Params is a separate class per usecase
/// (e.g. LoginParams) so signatures stay explicit and testable.
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// For usecases that take no parameters (e.g. GetCurrentUser).
class NoParams {
  const NoParams();
}
