import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uno_assignment/models/location_data.dart';
import 'package:uno_assignment/providers/dashboard_provider.dart';

class DashboardScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(dashboardProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Location Tracker'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: dashboardState.isTracking
                    ? null
                    : () =>
                        ref.read(dashboardProvider.notifier).startTracking(),
                child: Text('Start Tracking'),
              ),
              ElevatedButton(
                onPressed: dashboardState.isTracking
                    ? () => ref.read(dashboardProvider.notifier).stopTracking()
                    : null,
                child: Text('Stop Tracking'),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: dashboardState.locations.length,
              itemBuilder: (context, index) {
                final LocationData location = dashboardState.locations[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text('Time: ${location.timestamp}'),
                    subtitle: Text(
                        'Lat: ${location.latitude}, Lng: ${location.longitude}\nAddress: ${location.address}'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
