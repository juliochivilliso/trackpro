// ==============================================
// Route Point Model — stores GPS history data
// Used for 2-year history and route playback
// ==============================================

import 'package:hive/hive.dart';

part 'route_point.g.dart';

@HiveType(typeId: 1)
class RoutePoint extends HiveObject {
  @HiveField(0)
  final double lat;

  @HiveField(1)
  final double lng;

  @HiveField(2)
  final double speed;

  @HiveField(3)
  final double heading;

  @HiveField(4)
  final DateTime timestamp;

  @HiveField(5)
  final String vehicleId;

  RoutePoint({
    required this.lat,
    required this.lng,
    this.speed = 0,
    this.heading = 0,
    required this.timestamp,
    required this.vehicleId,
  });
}

@HiveType(typeId: 2)
class GpsAlert extends HiveObject {
  @HiveField(0)
  final String type; // 'info', 'warning', 'critical'

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String message;

  @HiveField(3)
  final DateTime timestamp;

  @HiveField(4)
  final String vehicleId;

  @HiveField(5)
  bool dismissed;

  GpsAlert({
    required this.type,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.vehicleId,
    this.dismissed = false,
  });
}
