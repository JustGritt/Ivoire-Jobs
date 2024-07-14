import 'package:barassage_app/features/admin_app/models/banned_user.dart';
import 'package:barassage_app/config/api_endpoints.dart';
import 'package:barassage_app/config/app_http.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

class BannedUsersProvider extends ChangeNotifier {
  List<BannedUser> _users = [];
  bool isLoading = false;
  String errorMessage = '';
  final AppHttp _http = AppHttp();

  List<BannedUser> get users => _users;

  Future<List<BannedUser>> getAllBannedUsers() async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();
    try {
      Response res = await _http.get('${ApiEndpoint.bannedUsers}');
      if (res.statusCode == 200 && res.data is List) {
        _users = List<BannedUser>.from(res.data.map((item) => BannedUser.fromJson(item)));
      } else {
        errorMessage = "Unexpected response format";
      }
    } catch (e) {
      errorMessage = "Error fetching banned users: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return _users;
  }
}
