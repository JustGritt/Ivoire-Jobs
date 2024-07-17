import 'package:barassage_app/core/helpers/services_helper.dart';

enum BookingStatus {
  created,
  fulfilled,
  cancelled,
}

BookingStatus bookingStatusFromString(String status) {
  switch (status) {
    case 'created':
      return BookingStatus.created;
    case 'fulfilled':
      return BookingStatus.fulfilled;
    case 'cancelled':
      return BookingStatus.cancelled;
    default:
      return BookingStatus.created;
  }
}

class BookingAppointment {
  String id;
  String userId;
  BookingStatus status;
  DateTime startTime;
  DateTime endTime;
  BookingAppointmentContact contact;
  BookingAppointmentService service;

  BookingAppointment({
    required this.id,
    required this.userId,
    required this.status,
    required this.startTime,
    required this.endTime,
    required this.contact,
    required this.service,
  });

  factory BookingAppointment.fromJson(Map<String, dynamic> json) =>
      BookingAppointment(
        id: json["ID"],
        userId: json["userID"],
        status: bookingStatusFromString(json["status"]),
        startTime: DateTime.parse(json["startTime"]),
        endTime: DateTime.parse(json["endTime"]),
        contact: BookingAppointmentContact.fromJson(json["contact"]),
        service: BookingAppointmentService.fromJson(json["service"]),
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "userID": userId,
        "status": status,
        "startTime": startTime.toIso8601String(),
        "endTime": endTime.toIso8601String(),
        "contact": contact.toJson(),
        "service": service.toJson(),
      };

  static List<BookingAppointment> fromJsonList(List<dynamic> jsonList) {
    return List<BookingAppointment>.from(
        jsonList.map((x) => BookingAppointment.fromJson(x)));
  }
}

class BookingAppointmentContact {
  String id;
  String firstName;
  String lastName;
  String email;
  DateTime createdAt;

  BookingAppointmentContact({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.createdAt,
  });

  factory BookingAppointmentContact.fromJson(Map<String, dynamic> json) =>
      BookingAppointmentContact(
        id: json["ID"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "createdAt": createdAt.toIso8601String(),
      };

  static List<BookingAppointmentContact> fromJsonList(List<dynamic> jsonList) {
    return List<BookingAppointmentContact>.from(
        jsonList.map((x) => BookingAppointmentContact.fromJson(x)));
  }
}

class BookingAppointmentService {
  String id;
  String userId;
  String title;
  String description;
  String price;
  int duration;
  List<BookingAppointmentServiceImage> images;
  DateTime createdAt;

  BookingAppointmentService({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.price,
    required this.duration,
    required this.images,
    required this.createdAt,
  });

  factory BookingAppointmentService.fromJson(Map<String, dynamic> json) =>
      BookingAppointmentService(
        id: json["ID"],
        userId: json["userID"],
        title: json["title"],
        description: json["description"],
        price: ServicesHelper.getFormattedPrice(json['price']),
        duration: json["duration"],
        images: BookingAppointmentServiceImage.fromJsonList(json["image"]),
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "userID": userId,
        "title": title,
        "description": description,
        "price": price,
        "duration": duration,
        "image": List<dynamic>.from(images.map((x) => x.toJson())),
        "createdAt": createdAt.toIso8601String(),
      };

  static List<BookingAppointmentService> fromJsonList(List<dynamic> jsonList) {
    return List<BookingAppointmentService>.from(
        jsonList.map((x) => BookingAppointmentService.fromJson(x)));
  }
}

class BookingAppointmentServiceImage {
  String url;

  BookingAppointmentServiceImage({
    required this.url,
  });

  factory BookingAppointmentServiceImage.fromJson(Map<String, dynamic> json) =>
      BookingAppointmentServiceImage(
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
      };

  static List<BookingAppointmentServiceImage> fromJsonList(
      List<dynamic> jsonList) {
    return List<BookingAppointmentServiceImage>.from(
        jsonList.map((x) => BookingAppointmentServiceImage.fromJson(x)));
  }
}
