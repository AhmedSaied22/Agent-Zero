abstract class Failure {
  final String message;
  const Failure({required this.message});
}

class ServerFailure extends Failure {
  ServerFailure({required super.message});

  factory ServerFailure.fromJson(Map<String, dynamic> json) {
    return ServerFailure(
      message: json['error'] ?? json['message'] ?? "Server Error",
    );
  }
}

class CacheFailure extends Failure {
  CacheFailure({required super.message});
}
