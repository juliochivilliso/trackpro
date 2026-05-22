// ==============================================
// Fleet Data Provider
// Manages the state of all vehicles and map state
// ==============================================

import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import '../models/vehicle.dart';
import '../models/route_point.dart';

class FleetProvider extends ChangeNotifier {
  List<Vehicle> _vehicles = [];
  String? _selectedVehicleId;
  bool _isFollowing = true;
  double _zoomLevel = 15.0;
  List<GpsAlert> _alerts = [];
  
  // Real-time route tracking
  final Map<String, List<RoutePoint>> _liveRoutes = {};

  // Getters
  List<Vehicle> get vehicles => _vehicles;
  Vehicle? get selectedVehicle {
    if (_vehicles.isEmpty) return null;
    if (_selectedVehicleId == null) return _vehicles.first;
    try {
      return _vehicles.firstWhere((v) => v.id == _selectedVehicleId);
    } catch (_) {
      return _vehicles.first;
    }
  }
  bool get isFollowing => _isFollowing;
  double get zoomLevel => _zoomLevel;
  List<GpsAlert> get activeAlerts => _alerts.where((a) => !a.dismissed).toList();
  List<RoutePoint> getSelectedRoute() {
    if (selectedVehicle == null) return [];
    return _liveRoutes[selectedVehicle!.id] ?? [];
  }

  // Simulator
  Timer? _simTimer;

  FleetProvider() {
    _initFleet();
  }

  void _initFleet() {
    // Load sample data
    _vehicles = Vehicle.sampleFleet();
    _selectedVehicleId = _vehicles.first.id;
    
    // Init route map
    for (var v in _vehicles) {
      _liveRoutes[v.id] = [
        RoutePoint(lat: v.lat, lng: v.lng, speed: v.speed, heading: v.heading, timestamp: DateTime.now(), vehicleId: v.id)
      ];
    }
    
    // Initial alert
    _addAlert(GpsAlert(
      type: 'info',
      title: 'System Nominal',
      message: 'All sensors operating within normal parameters. AntiGravity OS loaded.',
      timestamp: DateTime.now(),
      vehicleId: 'system',
    ));
    
    _startSimulation();
    notifyListeners();
  }

  // --- ACTIONS ---

  void selectVehicle(String id) {
    if (_selectedVehicleId != id) {
      _selectedVehicleId = id;
      _isFollowing = true; // Auto-follow when switching
      notifyListeners();
    }
  }

  void toggleFollow() {
    _isFollowing = !_isFollowing;
    notifyListeners();
  }
  
  void setZoom(double z) {
    _zoomLevel = z;
    notifyListeners();
  }
  
  void dismissAlert(GpsAlert alert) {
    alert.dismissed = true;
    notifyListeners();
  }

  // --- CRITICAL COMMANDS ---

  void executeEngineCut(String vehicleId) {
    final v = _vehicles.firstWhere((v) => v.id == vehicleId);
    v.engineCut = true;
    v.accOn = false;
    v.speed = 0.0;
    
    _addAlert(GpsAlert(
      type: 'critical',
      title: 'Engine Cut-off Executed',
      message: 'Remote relay command sent to ${v.name}. Engine disabled.',
      timestamp: DateTime.now(),
      vehicleId: v.id,
    ));
    
    notifyListeners();
  }

  // --- SIMULATION ENGINE ---

  void _startSimulation() {
    final random = math.Random();
    _simTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      bool needNotify = false;
      
      for (var v in _vehicles) {
        if (!v.online || !v.accOn || v.engineCut) continue;
        
        needNotify = true;
        
        // Jitter coordinates to simulate GPS noise/movement
        double dLat = (random.nextDouble() - 0.5) * 0.0002;
        double dLng = (random.nextDouble() - 0.5) * 0.0002;
        
        v.lat += dLat;
        v.lng += dLng;
        
        // Calculate heading
        v.heading = (math.atan2(dLng, dLat) * 180 / math.pi + 360) % 360;
        
        // Jitter speed (0 to 120 km/h)
        v.speed = math.max(0.0, v.speed + (random.nextDouble() - 0.45) * 10);
        v.speed = math.min(v.speed, 120.0);
        
        // Signal jitter
        if (random.nextDouble() > 0.8) {
          v.signal = math.max(1, math.min(5, v.signal + (random.nextDouble() > 0.5 ? 1 : -1)));
        }
        
        // Save route point
        final routes = _liveRoutes[v.id]!;
        routes.add(RoutePoint(
          lat: v.lat, lng: v.lng, speed: v.speed, heading: v.heading, 
          timestamp: DateTime.now(), vehicleId: v.id
        ));
        
        // Keep last 100 points
        if (routes.length > 100) {
          routes.removeAt(0);
        }
        
        // Speed limit check
        if (v.speed > 80.0 && random.nextDouble() > 0.7) {
          _addAlert(GpsAlert(
             type: 'warning',
             title: 'Speed Alert',
             message: '${v.name} exceeding 80 km/h limit.',
             timestamp: DateTime.now(),
             vehicleId: v.id,
          ));
        }
      }
      
      // Simulate battery drain on the truck
      final truck = _vehicles[2];
      if (truck.battery > 5) {
        truck.battery -= 1;
        needNotify = true;
        if (truck.battery == 25 && random.nextDouble() > 0.5) {
          _addAlert(GpsAlert(
             type: 'critical',
             title: 'Low Battery',
             message: '${truck.name} backup battery dropping critically low.',
             timestamp: DateTime.now(),
             vehicleId: truck.id,
          ));
        }
      }
      
      if (needNotify) {
        notifyListeners();
      }
    });
  }
  
  void _addAlert(GpsAlert alert) {
    _alerts.insert(0, alert);
    // Keep max 20 alerts
    if (_alerts.length > 20) {
      _alerts.removeLast();
    }
  }

  @override
  void dispose() {
    _simTimer?.cancel();
    super.dispose();
  }
}
