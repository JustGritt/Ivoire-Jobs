class LocationService {
  double latitude;
  double longitude;
  String city;
  String address;
  String? postCode;
  String? country;

  LocationService({
    required this.latitude,
    required this.longitude,
    required this.city,
    required this.address,
    this.postCode,
    this.country,
  });

  factory LocationService.fromJson(Map<String, dynamic> json) =>
      LocationService(
        latitude: json["latitude"],
        longitude: json["longitude"],
        city: json["city"],
        postCode: json["postCode"],
        country: json["country"],
        address: json["address"],
      );

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
        "city": city,
        "postCode": postCode,
        "country": country,
        "address": address,
      };

  LocationService copyWith({
    double? latitude,
    double? longitude,
    String? city,
    String? postCode,
    String? country,
    String? address,
  }) {
    return LocationService(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      city: city ?? this.city,
      postCode: postCode ?? this.postCode,
      country: country ?? this.country,
      address: address ?? this.address,
    );
  }
}
