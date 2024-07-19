class BookingCreatedOutput {
  final String bookingId;
  final String userId;
  final String serviceId;
  final String status;
  final DateTime startTime;
  final DateTime endTime;

  BookingCreatedOutput({
    required this.bookingId,
    required this.userId,
    required this.serviceId,
    required this.status,
    required this.startTime,
    required this.endTime,
  });

  factory BookingCreatedOutput.fromJson(Map<String, dynamic> json) {
    return BookingCreatedOutput(
      bookingId: json['ID'] as String,
      userId: json['userID'] as String,
      serviceId: "",
      status: "",
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': bookingId,
      'userID': userId,
      'serviceID': serviceId,
      'status': status,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
    };
  }
}

class BookingServiceCreatedModel {
  final BookingCreatedOutput booking;
  final String paymentIntent;

  BookingServiceCreatedModel({
    required this.booking,
    required this.paymentIntent,
  });

  factory BookingServiceCreatedModel.fromJson(Map<String, dynamic> json) {
    return BookingServiceCreatedModel(
      booking: BookingCreatedOutput.fromJson(json['booking']),
      paymentIntent: json['paymentIntent'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'booking': booking.toJson(),
      'paymentIntent': paymentIntent,
    };
  }
}
