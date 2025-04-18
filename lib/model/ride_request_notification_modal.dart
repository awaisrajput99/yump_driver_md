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
    final departureLocation = map['departure_location'] ?? {};

    return RideRequestNotificationModel(
      sessionId: map['session_id'] ?? '',
      destinationName: map['destination_name'] ?? '',
      departureName: map['departure_name'] ?? '',
      departureLat: double.tryParse(departureLocation['lat'].toString()) ?? 0.0,
      departureLng: double.tryParse(departureLocation['lng'].toString()) ?? 0.0,
      pickupTime: map['pickup_time'] ?? '',
      passengerName: map['passenger_name'] ?? '',
      totalDistance: map['total_distance'] ?? '',
    );
  }
}