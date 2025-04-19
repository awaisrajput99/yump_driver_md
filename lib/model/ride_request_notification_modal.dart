class RideRequestNotificationModel {
  final String sessionId;
  final String destinationName;
  final String departureName;
  final double departureLat;
  final double departureLng;
  final String pickupTime;
  final String passengerName;
  final String totalDistance;

  RideRequestNotificationModel({
    required this.sessionId,
    required this.destinationName,
    required this.departureName,
    required this.departureLat,
    required this.departureLng,
    required this.pickupTime,
    required this.passengerName,
    required this.totalDistance,
  });

  factory RideRequestNotificationModel.fromMap(Map<String, dynamic> map) {
    return RideRequestNotificationModel(
      sessionId: map['session_id']?.toString() ?? '',
      destinationName: map['destination_name']?.toString() ?? '',
      departureName: map['departure_name']?.toString() ?? '',
      departureLat: double.tryParse(map['departure_location_lat']?.toString() ?? '0.0') ?? 0.0,
      departureLng: double.tryParse(map['departure_location_lng']?.toString() ?? '0.0') ?? 0.0,
      pickupTime: map['pickup_time']?.toString() ?? '',
      passengerName: map['passenger_name']?.toString() ?? '',
      totalDistance: map['total_distance']?.toString() ?? '',
    );
  }

}