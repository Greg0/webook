class StatusResponse {
  final String message;
  final int progress;

  StatusResponse({required this.message, required this.progress});

  factory StatusResponse.fromJson(Map<String, dynamic> json) {
    return StatusResponse(
        message: json['message'],
        progress: json['progress']
    );
  }
}