/// Thrown by remote data sources when the backend returns an error
/// response (4xx/5xx). Carries the message from the API's JSON body.
class ServerException implements Exception {
  final String message;
  const ServerException(this.message);
}

/// Thrown when there's no network connectivity before even
/// attempting the request.
class NetworkException implements Exception {
  final String message;
  const NetworkException([this.message = 'No internet connection']);
}

/// Thrown by local data sources (secure storage) on read/write failure.
class CacheException implements Exception {
  final String message;
  const CacheException([this.message = 'Local storage error']);
}
