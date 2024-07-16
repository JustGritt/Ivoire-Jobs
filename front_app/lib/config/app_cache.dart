import 'package:barassage_app/features/auth_mod/models/models.dart';
import 'package:barassage_app/core/classes/cache_manager.dart';
import 'dart:convert';

class AppCacheToken {
  String? token;
  AppCacheToken({this.token});
}

class AppCache {
  Map<String, String>? udata;

  void doLogin(User user, String token) {
    Cache.saveData('user', user.toJsonEncodable());
    Cache.saveData('token', token);
  }

  Future<Map<String, String>> auth() async {
    var data = await Cache.readData('auth_data');
    return udata = jsonDecode(data);
  }

  Future<String?> getToken() async {
    String? token = await Cache.readData('token');
    return token;
  }

  Future<User?> getUser() async {
    var data = await Cache.readData('user');
    if (data != null) {
      return User.fromJson(jsonDecode(data));
    }
    return null;
  }

  Future<void> setUser(User user) async {
    Cache.saveData('user', user.toJsonEncodable());
  }

  Future<String> setToken() async {
    String token = await Cache.readData('token');
    return token;
  }

  Future<bool> isLogin() async {
    var data = await Cache.readData('token');
    if (data != null) {
      return true;
    }
    return false;
  }

  void doLogout() {
    Cache.deleteData('auth_data');
    Cache.deleteData('user');
    Cache.deleteData('token');
  }

  Future<bool> isLogout() async {
    var data = await Cache.readData('auth_data');
    if (data == null) {
      return true;
    }
    return false;
  }
}
