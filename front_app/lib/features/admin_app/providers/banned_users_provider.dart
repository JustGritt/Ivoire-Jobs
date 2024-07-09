import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:barassage_app/config/api_endpoints.dart';
import 'package:barassage_app/config/app_http.dart';
import 'package:barassage_app/features/admin_app/models/banned_user.dart';

class BannedUsersProvider extends ChangeNotifier {
  List<BannedUser> _users = [];
  bool isLoading = false;
  final AppHttp _http = AppHttp();

  List<BannedUser> get users => _users;

  Future<List<BannedUser>> getAllBannedUsers() async {
    isLoading = true;
    notifyListeners();
    try {
      Response res = await _http.get('${ApiEndpoint.bannedUsers}');
      if (res.statusCode == 200 && res.data is List) {
        print(res.data);
        _users = List<BannedUser>.from(res.data.map((item) {
          try {
            return BannedUser.fromJson(item);
          } catch (e) {
            print("Error parsing user: $item");
            print(e);
            return null; // Skip invalid entries
          }
        }).where((element) => element != null));
      } else {
        print("Unexpected response format");
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return _users;
  }
}
