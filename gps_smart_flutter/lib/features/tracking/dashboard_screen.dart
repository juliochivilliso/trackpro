import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

import '../../core/design_system/hud_theme.dart';
import '../../data/providers/fleet_provider.dart';
import '../../data/models/vehicle.dart';

// ==============================================
// Mobile Map Screen - Innovative & User Friendly
// ==============================================
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Innovative glass feeling
      extendBody: true,
      
      // Floating App Bar / Header
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: ClipRRect(
          borderRadius: BorderRadius.circular(HudRadius.pill),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: HudColors.panelBg, // Glass effect background
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8, height: 8,
                  decoration: const BoxDecoration(color: HudColors.green, shape: BoxShape.circle),
                ),
                const SizedBox(width: 8),
                Text('TRACKPRO LIVE', style: HudText.label(color: HudColors.textPrimary)),
              ],
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: HudColors.textPrimary),
            onPressed: () {},
          )
        ],
      ),

      // Main Content: Map + Bottom Sheet
      body: const _MapWithBottomSheet(),

      // Modern Bottom Navigation
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: HudColors.deepBlack.withOpacity(0.9),
          border: const Border(top: BorderSide(color: HudColors.border, width: 0.5)),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: HudColors.cyan,
          unselectedItemColor: HudColors.textSecondary,
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.map_rounded), label: 'Mapa'),
            BottomNavigationBarItem(icon: Icon(Icons.directions_car), label: 'Flota'),
            BottomNavigationBarItem(icon: Icon(Icons.warning_amber_rounded), label: 'Alertas'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Perfil'),
          ],
        ),
      ),
    );
  }
}

class _MapWithBottomSheet extends StatelessWidget {
  const _MapWithBottomSheet();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const _InteractiveMap(),
        
        // Draggable Bottom Sheet for Fleet
        DraggableScrollableSheet(
          initialChildSize: 0.25,
          minChildSize: 0.15,
          maxChildSize: 0.85, // Smooth transition from glimpse to full list
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: HudColors.panelBg, // Glass effect
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                border: const Border(
                  top: BorderSide(color: HudColors.border, width: 1),
                ),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 20, spreadRadius: 5)
                ]
              ),
              child: CustomScrollView(
                controller: scrollController,
                slivers: [
                  SliverToBoxAdapter(
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 12, bottom: 20),
                        height: 5,
                        width: 40,
                        decoration: BoxDecoration(
                          color: HudColors.textSecondary.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                      child: Text('Vehículos Activos', style: HudText.heading(size: 20)),
                    ),
                  ),
                  Consumer<FleetProvider>(
                    builder: (context, fleet, child) {
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final vehicle = fleet.vehicles[index];
                            return _VehicleListItem(vehicle: vehicle, fleet: fleet);
                          },
                          childCount: fleet.vehicles.length,
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _InteractiveMap extends StatelessWidget {
  const _InteractiveMap();

  @override
  Widget build(BuildContext context) {
    return Consumer<FleetProvider>(
      builder: (context, fleet, child) {
        final center = fleet.selectedVehicle != null 
            ? LatLng(fleet.selectedVehicle!.lat, fleet.selectedVehicle!.lng)
            : const LatLng(18.486, -69.931);

        return FlutterMap(
          options: MapOptions(
            initialCenter: center,
            initialZoom: 14.0,
          ),
          children: [
            TileLayer(
              // Futuristic Dark Map
              urlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
              subdomains: const ['a', 'b', 'c', 'd'],
            ),
            
            // Dynamic Markers
            MarkerLayer(
              markers: fleet.vehicles.map((v) {
                final isSelected = fleet.selectedVehicle?.id == v.id;
                return Marker(
                  point: LatLng(v.lat, v.lng),
                  width: 50,
                  height: 50,
                  child: GestureDetector(
                    onTap: () => fleet.selectVehicle(v.id),
                    child: _VehicleMarker(vehicle: v, isSelected: isSelected),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}

class _VehicleMarker extends StatelessWidget {
  final Vehicle vehicle;
  final bool isSelected;

  const _VehicleMarker({required this.vehicle, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final statusColor = vehicle.online ? HudColors.cyan : HudColors.textSecondary;
    
    return Stack(
      alignment: Alignment.center,
      children: [
        // Pulse effect if selected
        if (isSelected)
           Container(
             width: 50, height: 50,
             decoration: BoxDecoration(
               shape: BoxShape.circle,
               color: statusColor.withOpacity(0.2),
             ),
           ),
        
        // Heading arrow
        Transform.rotate(
          angle: vehicle.heading * (math.pi / 180),
          child: Container(
            width: 32, height: 32,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                 BoxShadow(color: statusColor.withOpacity(0.5), blurRadius: 10)
              ]
            ),
            child: const Center(
              child: Icon(Icons.navigation, color: Colors.white, size: 16),
            ),
          ),
        ),
      ],
    );
  }
}

class _VehicleListItem extends StatelessWidget {
  final Vehicle vehicle;
  final FleetProvider fleet;

  const _VehicleListItem({required this.vehicle, required this.fleet});

  @override
  Widget build(BuildContext context) {
    final isSelected = fleet.selectedVehicle?.id == vehicle.id;
    final isOnline = vehicle.online;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? HudColors.cyan.withOpacity(0.1) : HudColors.cardBg,
        borderRadius: BorderRadius.circular(HudRadius.card),
        border: Border.all(
          color: isSelected ? HudColors.cyan : HudColors.border,
          width: 1,
        ),
      ),
      child: ListTile(
        onTap: () => fleet.selectVehicle(vehicle.id),
        leading: Container(
          width: 44, height: 44,
          decoration: BoxDecoration(
            color: HudColors.deepBlack,
            shape: BoxShape.circle,
            border: Border.all(color: isOnline ? HudColors.green : HudColors.textSecondary),
          ),
          child: Center(
            child: Icon(Icons.directions_car, color: isOnline ? HudColors.textPrimary : HudColors.textSecondary, size: 20),
          ),
        ),
        title: Text(vehicle.name, style: HudText.body(size: 15)),
        subtitle: Text(vehicle.plate, style: HudText.mono(size: 12, color: HudColors.textSecondary)),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('${vehicle.speed.round()} km/h', style: HudText.mono(color: isOnline && vehicle.speed > 0 ? HudColors.cyan : HudColors.textSecondary)),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.battery_full, size: 12, color: vehicle.battery > 20 ? HudColors.green : HudColors.red),
                const SizedBox(width: 4),
                Text('${vehicle.battery}%', style: HudText.label()),
              ],
            )
          ],
        ),
      ),
    );
  }
}
