class ApiResponse {
  int code;
  String message;
  dynamic body; // since the body can be of any type

  ApiResponse({required this.code, required this.message, required this.body});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      code: json['code'],
      message: json['message'],
      body: json['body'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    data['body'] = body;
    return data;
  }
}
