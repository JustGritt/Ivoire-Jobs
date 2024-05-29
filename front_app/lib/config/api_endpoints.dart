import '../features/features.dart';

/// In this file we will be writing all API Endpoints using this application

class ApiEndpoint {
  // News Server
  static const rapidUrl = 'https://free-news.p.rapidapi.com';
  static const apiUrl = 'http://192.168.1.54:8000';
  static const news = '$rapidUrl/v1/search';

  // Server Links
  static const baseUrl = 'http://localhost:8000';
  static const api = '${baseUrl}/api/v1';

  // Enqueries Endpoints
  static const enqueries = '${api}enqueries?populate=*&sort[0]=id%3Adesc';
  static const enquery = '${api}enqueries';

  // Apps Internals Links
  static const appLoginUrl = AuthApp.login;
  static const appRegiaterUrl = AuthApp.register;
  static const appForgetUrl = AuthApp.forget;
  static const appProfileUrl = AuthApp.profile;
  static const appEmailValidationUrl = AuthApp.emailValidation;
}
