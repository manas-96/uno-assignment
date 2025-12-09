import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uno_assignment/controllers/dashboard_controller.dart';
import 'package:uno_assignment/models/location_data.dart';

class DashboardScreen extends StatelessWidget {
  final DashboardController _controller = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Tracker'),
      ),
      body: Column(
        children: [
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _controller.isTracking.value ? null : _controller.startTracking,
                  child: Text('Start Tracking'),
                ),
                ElevatedButton(
                  onPressed: _controller.isTracking.value ? _controller.stopTracking : null,
                  child: Text('Stop Tracking'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(
              () => ListView.builder(
                itemCount: _controller.locations.length,
                itemBuilder: (context, index) {
                  final LocationData location = _controller.locations[index];
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
          ),
        ],
      ),
    );
  }
}
