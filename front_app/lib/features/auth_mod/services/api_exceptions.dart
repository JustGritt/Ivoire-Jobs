class ErrorResponse {
  int code;
  String message;

  ErrorResponse({required this.code, required this.message});

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      code: json['code'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    return data;
  }
}

class APIException {
  List<ErrorResponse> errors;

  APIException({required this.errors});

  factory APIException.fromJson(Map<String, dynamic> json) {
    var errorList = json['errors'] as List;
    List<ErrorResponse> errors = errorList
        .map((errorJson) => ErrorResponse.fromJson(errorJson))
        .toList();

    return APIException(errors: errors);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['errors'] = this.errors.map((error) => error.toJson()).toList();
    return data;
  }
}
