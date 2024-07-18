import 'package:barassage_app/features/features.dart';
// import 'package:barassage_app/features/admin_app/admin_app.dart';

/// In this file we will be writing all API Endpoints using this application

class ApiEndpoint {
  // News Server

  // Server Links
  // static const baseUrl = 'http://localhost:8000';
  // static const baseUrl = 'http://10.0.2.2:8000';
  static const baseUrl = 'https://api.barassage.com';
  // static const baseUrl = 'https://fantastic-space-doodle-w59vv7w5w7pfp9j-8000.app.github.dev';
  static const api = '${baseUrl}/api/v1';

  // Enqueries Endpoints
  static const enqueries = '${api}enqueries?populate=*&sort[0]=id%3Adesc';
  static const enquery = '${api}enqueries';

  // Apps Internals Links
  static const appLoginUrl = AuthApp.login;
  static const appRegisterUrl = AuthApp.register;
  static const appForgetUrl = AuthApp.forget;
  static const appProfileUrl = AuthApp.profile;
  static const appEmailValidationUrl = '${api}/auth/verify-email';

  // Admin App Links
  static const adminUsers = '${api}/auth/users';
  static const serviceCollection = '${api}/service/collection';
  static const dashboardSettings = '${api}/configuration';
  static const banUser = '${api}/ban';
  static const adminLogin = '${api}/auth/admin-login';
  static const adminUser = '${api}/auth/admin';
  static const addAdmin = '${api}/auth/register-admin';
  static const memberRoute = '${api}/member';
  static const approveMember = '${api}/member/:id/validate';
  static const adminDashboardStats = '${api}/dashboard/stats';

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
  // Ratings Endpoints
  static const ratings = '${api}/rating';
  static const serviceRatings = '${api}/service/:id/rating';
  // Booking Endpoints
  static const userBookings = '${api}/booking/user/:id';
  // static const userBookings = '${api}/booking/collection';
  // Push Token
  static const pushTokens = '/auth/update-token';
  // Notifications preferences
  static const notificationPreferences = '/notification-preference';
  // become barasseur
  static const becomeBarasseur = '/member';
  // Booking Services
  static const bookingServices = '/booking';
  static const bookings = '/booking/collection';
  // Reports Endpoints
  static const report = '${api}/report';
  static const reports = '${api}/report/pending';
  static const reportsDetails = '${api}/report/:id';
  // Ban Endpoints
  static const bannedUsers = '${api}/ban/collection';
  // Rooms chats Endpoints
  static const roomsChats = '/room/collection';

  // categories Endpoints
  static const categories = '${api}/category';
  // categories collection
  static const categoriesCollection = '${api}/category/collection';

  // bookings collection
  static const bookingsCollection = '${api}/booking/collection';

  // Logs Endpoints
  // logs collection
  static const logsCollection = '${api}/log/collection';
}
