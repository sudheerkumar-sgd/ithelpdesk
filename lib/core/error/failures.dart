import 'package:equatable/equatable.dart';
import 'package:smartuaq/core/constants/constants.dart';

const String unknownErroeMessage = 'An unknown error has occured';

abstract class Failure extends Equatable {
  String get errorMessage;
  @override
  List<Object?> get props => [];
}

class ServerFailure extends Failure {
  final String message;
  ServerFailure(this.message);

  @override
  List<Object> get props => [errorMessage];

  @override
  String toString() {
    return 'ServerFailure{errorMessage: $errorMessage}';
  }

  @override
  String get errorMessage => message.isNotEmpty ? message : unknownErroeMessage;
}

class ConnectionFailure extends Failure {
  final String message = isSelectedLocalEn
      ? 'No Internet Connection'
      : 'يرجى التأكد من تشغيل Wi-Fi';

  @override
  List<Object> get props => [message];

  @override
  String toString() {
    return 'ConnectionFailure{message: $message}';
  }

  @override
  String get errorMessage => message;
}

class UnknownFailure extends Failure {
  final String message = 'An unknown error has occured';

  @override
  List<Object> get props => [message];

  @override
  String toString() {
    return 'ConnectionFailure{message: $message}';
  }

  @override
  String get errorMessage => message;
}

class Exception extends Failure {
  final String exception;
  Exception(this.exception);

  @override
  List<Object> get props => [errorMessage];

  @override
  String toString() {
    return 'Exception{exception: $exception}';
  }

  @override
  String get errorMessage =>
      exception.isNotEmpty ? exception : unknownErroeMessage;
}
