class FileNotFoundException implements Exception {}

class ErrorFileException implements Exception {}

class CacheException implements Exception {}

class ServerException implements Exception {
  final String message;

  const ServerException({required this.message});
}

class NetworkException implements Exception {}

///can be used for throwing [NoInternetException]
class NoInternetException implements Exception {
  late String _message;

  NoInternetException([String message = 'NoInternetException Occurred']) {
    _message = message;
  }

  @override
  String toString() {
    return _message;
  }
}
