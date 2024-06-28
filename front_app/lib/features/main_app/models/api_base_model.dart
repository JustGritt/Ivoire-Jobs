class ApiBaseModel {
  int code;
  String message;
  dynamic body;

  ApiBaseModel({required this.code, required this.message, required this.body});

  factory ApiBaseModel.fromJson(Map<String, dynamic> json) {
    return ApiBaseModel(
        code: json['code'], message: json['message'], body: json['body']);
  }
}
