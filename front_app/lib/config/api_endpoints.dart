import 'package:barassage_app/features/admin_app/admin_app.dart';

import '../features/features.dart';

/// In this file we will be writing all API Endpoints using this application

class ApiEndpoint {
  // News Server

  // Server Links
  //static const baseUrl = 'https://api.barassage.com';
  static const baseUrl = 'https://fantastic-space-doodle-w59vv7w5w7pfp9j-8000.app.github.dev';
  static const api = '${baseUrl}/api/v1';

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
  static const adminUsers = '${api}/auth/users';
  static const serviceCollection = '${api}/service/collection';
  static const dashboardSettings =  '${api}/configuration';
  static const banUser = '${api}/ban';
  static const adminLogin = '${api}/auth/admin-login';
  static const adminUser = '${api}/auth/admin';
  static const addAdmin = '${api}/auth/register-admin';

  static const updateProfile = '/auth/update-profile';

  // My Services Endpoints
  static const myServices = '${api}/user/:id/service';
  // Services Endpoints
  static const services = '${api}/service';
  // Services collection
  static const servicesCollection = '${api}/service/collection';
  // Services details Endpoints
  static const serviceDetails = '${api}/service/:id';
  // Services Categories Endpoints
  static const serviceCategories = '/category/collection';
  // Push Token
  static const pushTokens = '/auth/update-token';
  // Notifications preferences
  static const notificationPreferences = '/user/notification-preference';
  // become barasseur
  static const becomeBarasseur = '/member';
  // Reports Endpoints
  static const reports = '${api}/report/pending';
  static const reportsDetails = '${api}/report/:id';
}
