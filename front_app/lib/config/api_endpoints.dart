import '../features/features.dart';

/// In this file we will be writing all API Endpoints using this application

class ApiEndpoint {
  // News Server

  // Server Links
  static const baseUrl = 'https://api.barassage.com';
  static const api = '${baseUrl}/api/v1';

  // Enqueries Endpoints
  static const enqueries = '${api}enqueries?populate=*&sort[0]=id%3Adesc';
  static const enquery = '${api}enqueries';

  // Apps Internals Links
  static const appLoginUrl = AuthApp.login;
  static const appRegisterUrl = AuthApp.register;
  static const appForgetUrl = AuthApp.forget;
  static const appProfileUrl = AuthApp.profile;

  // My Services Endpoints
  static const myServices = '${api}/user/:id/service';
  // Services Endpoints
  static const services = '${api}/service';
  // Services details Endpoints
  static const serviceDetails = '${api}/service/:id';
  // Services Categories Endpoints
  static const serviceCategories = '/category/collection';
  // Push Token 
  static const pushTokens = '/auth/update-token';
  // become barasseur
  static const becomeBarasseur = '/member';
}
