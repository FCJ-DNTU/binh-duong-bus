import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class RoutePlanningScreen extends StatefulWidget {
  const RoutePlanningScreen({super.key});

  @override
  State<RoutePlanningScreen> createState() => _RoutePlanningScreenState();
}

class _RoutePlanningScreenState extends State<RoutePlanningScreen> {
  final MapController _mapController = MapController();
  final Location _location = Location();

  final TextEditingController _locationController = TextEditingController();

  bool isLoading = false;

  LatLng? _currentLocation;

  LatLng? _destination;

  List<LatLng> _route = [];

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    if (!await _checktheRequestPermissions()) return;

    // listen for the location update and update the current location.
    _location.onLocationChanged.listen((LocationData locationData) {
      if (locationData.latitude != null && locationData.longitude != null) {
        setState(() {
          _currentLocation =
              LatLng(locationData.latitude!, locationData.longitude!);
          isLoading = false; // stop loadin once the cocation is obtained.
        });
      }
    });
  }

  // method to fetch coordinates points from user given location
  Future<void> _fetchCoordinatesPoints(String location) async {
    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=$location&format=json&limit=1');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data.isNotEmpty) {
        final lat = double.parse(data[0]['lat']);
        final lon = double.parse(data[0]['lon']);

        setState(() {
          _destination = LatLng(lat, lon); // Set the destination coordinates.
        });

        await _fetchRoute();
      } else {
        errorMessage('Không thể tìm thấy điểm đến.');
      }
    } else {
      errorMessage('Tìm kiếm điểm đến thất bại. Hãy thử lại trong ít phút!');
    }
  }

  // method to fetch the route between the current location and the destination using the OSRM API
  Future<void> _fetchRoute() async {
    if (_currentLocation == null || _destination == null) return;

    final url = Uri.parse("http://router.project-osrm.org/route/v1/driving/"
        '${_currentLocation!.longitude},${_currentLocation!.latitude};'
        '${_destination!.longitude},${_destination!.latitude}?overview=full&geometries=polyline');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final geometry = data['routes'][0]['geometry'];
      _decodePolyline(
          geometry); // Decode the polyline into a list of coordinates.
    } else {
      errorMessage(
          "'Tìm kiếm tuyến đường thất bại. Hãy thử lại trong ít phút!'");
    }
  }

  // method to decode polyline to route coordinates
  void _decodePolyline(String encodedPolyline) {
    PolylinePoints polylinePoints = PolylinePoints();

    List<PointLatLng> decodedPoints =
        polylinePoints.decodePolyline(encodedPolyline);

    setState(() {
      _route = decodedPoints
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();
    });
  }

  Future<bool> _checktheRequestPermissions() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return false;
    }

    // check if location permissions are granted
    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return false;
    }
    return true;
  }

  Future<void> _userCurrentLocation() async {
    if (_currentLocation != null) {
      _mapController.move(_currentLocation!, 15);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Không thể lấy vị trí hiện tại."),
        ),
      );
    }
  }

  void errorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _currentLocation ?? LatLng(0, 0),
                    initialZoom: 2,
                    minZoom: 0,
                    maxZoom: 100,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                    ),
                    CurrentLocationLayer(
                      style: const LocationMarkerStyle(
                        marker: DefaultLocationMarker(
                          child: Icon(
                            Icons.location_pin,
                            color: Colors.white,
                          ),
                        ),
                        markerSize: Size(35, 35),
                        markerDirection: MarkerDirection.heading,
                      ),
                    ),
                    if (_currentLocation != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: _currentLocation!,
                            width: 50,
                            height: 50,
                            child: const Icon(
                              Icons.location_pin,
                              size: 40,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    if (_destination != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: _destination!,
                            width: 50,
                            height: 50,
                            child: const Icon(
                              Icons.location_pin,
                              size: 40,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    if (_currentLocation != null &&
                        _destination != null &&
                        _route.isNotEmpty)
                      PolylineLayer(
                        polylines: [
                          Polyline(
                              points: _route,
                              strokeWidth: 5,
                              color: Colors.lightBlue),
                        ],
                      ),
                  ],
                ),
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _locationController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Chọn điểm đến của bạn',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 20),
                      ),
                    ),
                  ),
                  // IconButton to trigger the search for the entered location.
                  IconButton(
                    style: IconButton.styleFrom(backgroundColor: Colors.white),
                    onPressed: () {
                      final location = _locationController.text.trim();
                      if (location.isNotEmpty) {
                        _fetchCoordinatesPoints(
                            location); // Fetch coordinates for the entered location.
                      }
                    },
                    icon: const Icon(Icons.search),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        onPressed: _userCurrentLocation,
        backgroundColor: Colors.blue,
        child: const Icon(
          Icons.my_location,
          size: 30,
          color: Colors.white,
        ),
      ),
    );
  }
}
