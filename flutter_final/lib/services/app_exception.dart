class AppException implements Exception {
  final String message;
  final dynamic responseData;

  AppException({required this.message, this.responseData});

  String toString() {
    return message;
  }
}

class NotFoundException extends AppException {
  NotFoundException({required super.message, super.responseData});
}
class TokenExpired extends AppException {
  TokenExpired({required super.message, super.responseData});
}
