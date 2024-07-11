import 'package:barassage_app/features/main_app/models/location_service.dart';
import 'package:jiffy/jiffy.dart';

class BookingServiceCreateModel {
  final LocationService location;
  final String phoneNumber;
  final DateTime startTime;
  final String serviceId;

  BookingServiceCreateModel(
      {required this.location,
      required this.serviceId,
      required this.startTime,
      required this.phoneNumber});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{
      'contact': location.toJson()..addAll({'phone': phoneNumber}),
      'serviceID': serviceId,
      'startTime':
          '${Jiffy.parse(startTime.toString()).format(pattern: 'yyyy-MM-ddTHH:mm:ss')}Z'
    };
    return data;
  }
}
