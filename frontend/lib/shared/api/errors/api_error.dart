class ApiError {
  final String message;
  final String errorCode;
  final String timestamp;

  ApiError({
    required this.message,
    required this.errorCode,
    required this.timestamp,
  });

  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      message: json['message'] ?? 'Unknown error',
      errorCode: json['errorCode'] ?? 'UNKNOWN_ERROR',
      timestamp: json['timestamp'] ?? DateTime.now().toIso8601String(),
    );
  }

  @override
  String toString() => 'AppException: $errorCode - $message';
}
