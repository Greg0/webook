class ErrorResponse implements Exception {
  final List<Error> errors;

  ErrorResponse(this.errors);

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(List.from(json['errors']
        .map((dynamic errorJson) => Error.fromJson(errorJson))));
  }
}

class Error {
  final String status;
  final String detail;

  Error(this.status, this.detail);

  factory Error.fromJson(dynamic json) {
    return Error(json['status'], json['detail']);
  }
}
