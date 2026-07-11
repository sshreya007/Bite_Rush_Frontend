import 'package:equatable/equatable.dart';

/// Base class for all failures the domain layer can return.
/// The data layer catches exceptions (network, server, cache) and
/// converts them into one of these, so presentation never deals
/// with raw exceptions/status codes directly.
abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

/// 4xx/5xx responses from the backend (e.g. "Invalid email or password",
/// "Email already registered").
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// No internet connection, timeout, DNS failure, etc.
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection']);
}

/// Local storage read/write issues (secure storage, shared prefs).
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Local storage error']);
}
