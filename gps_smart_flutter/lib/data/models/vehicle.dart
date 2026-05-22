// ==============================================
// Vehicle Data Model
// Represents a tracked vehicle with ST-901L data
// ==============================================

import 'package:hive/hive.dart';

part 'vehicle.g.dart';

@HiveType(typeId: 0)
class Vehicle extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String plate;

  @HiveField(3)
  String type; // 'car', 'moto', 'truck'

  @HiveField(4)
  bool online;

  @HiveField(5)
  double lat;

  @HiveField(6)
  double lng;

  @HiveField(7)
  double speed;

  @HiveField(8)
  double heading;

  @HiveField(9)
  int battery; // 0-100 (150mAh backup)

  @HiveField(10)
  int signal; // 0-5 bars

  @HiveField(11)
  bool accOn; // Engine ignition

  @HiveField(12)
  bool engineCut; // Remote relay cut

  @HiveField(13)
  String color; // Hex color for map marker

  @HiveField(14)
  String imei;

  Vehicle({
    required this.id,
    required this.name,
    required this.plate,
    this.type = 'car',
    this.online = true,
    this.lat = 18.486,
    this.lng = -69.931,
    this.speed = 0,
    this.heading = 0,
    this.battery = 100,
    this.signal = 4,
    this.accOn = false,
    this.engineCut = false,
    this.color = '#00E5FF',
    this.imei = '861234567890123',
  });

  /// Create sample fleet for demo
  static List<Vehicle> sampleFleet() {
    return [
      Vehicle(
        id: 'v1', name: 'Toyota Hilux', plate: 'A-123-456',
        type: 'car', online: true, lat: 18.486, lng: -69.931,
        speed: 42, heading: 45, battery: 87, signal: 4,
        accOn: true, color: '#00E5FF', imei: '861234567890123',
      ),
      Vehicle(
        id: 'v2', name: 'Honda CBR 600', plate: 'M-789-012',
        type: 'moto', online: true, lat: 18.482, lng: -69.928,
        speed: 28, heading: 120, battery: 65, signal: 3,
        accOn: true, color: '#00FF88', imei: '861234567890456',
      ),
      Vehicle(
        id: 'v3', name: 'Freightliner M2', plate: 'C-345-678',
        type: 'truck', online: false, lat: 18.490, lng: -69.935,
        speed: 0, heading: 270, battery: 34, signal: 1,
        accOn: false, color: '#FFAA00', imei: '861234567890789',
      ),
    ];
  }
}
