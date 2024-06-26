import 'package:barassage_app/features/admin_app/admin_app.dart';

import '../features/features.dart';

/// In this file we will be writing all API Endpoints using this application

class ApiEndpoint {
  // News Server
  static const rapidUrl = 'https://free-news.p.rapidapi.com';
  static const apiUrl = 'http://10.237.232.0:8000';
  static const news = '$rapidUrl/v1/search';

  // Server Links
  static const baseUrl = 'http://localhost:8000';
  static const api = '$baseUrl/api/v1';

  // Enqueries Endpoints
  static const enqueries = '${api}enqueries?populate=*&sort[0]=id%3Adesc';
  static const enquery = '${api}enqueries';

  // Apps Internals Links
  static const appLoginUrl = AuthApp.login;
  static const appRegisterUrl = AuthApp.register;
  static const appForgetUrl = AuthApp.forget;
  static const appProfileUrl = AuthApp.profile;
  static const appEmailValidationUrl = AuthApp.emailValidation;

  // Admin App Links
  static const adminUsers = AdminApp.users;

  // Services Endpoints
  static const services = '${api}services?populate=*&sort[0]=id%3Adesc';
  // Services Categories Endpoints
  static const serviceCategories = '${api}service/categories';
}
