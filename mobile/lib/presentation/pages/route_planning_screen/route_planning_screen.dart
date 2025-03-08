import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
  List<LatLng> _stopStations = [];

  final String apiUrl = dotenv.env['API_URL'] ?? "";

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    if (!await _checkPermissions()) return;
    _location.onLocationChanged.listen((LocationData locationData) {
      if (locationData.latitude != null && locationData.longitude != null) {
        setState(() {
          _currentLocation =
              LatLng(locationData.latitude!, locationData.longitude!);
          isLoading = false;
        });
      }
    });
  }

  Future<void> _fetchCoordinatesPoints(String location) async {
    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=$location&format=json&limit=1');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data.isNotEmpty) {
        setState(() {
          _destination = LatLng(
              double.parse(data[0]['lat']), double.parse(data[0]['lon']));
        });
        await _fetchRoute();
        await _fetchStopStations();
      } else {
        _showErrorMessage('Không thể tìm thấy điểm đến.');
      }
    } else {
      _showErrorMessage('Tìm kiếm điểm đến thất bại. Hãy thử lại!');
    }
  }

  Future<void> _fetchRoute() async {
    if (_currentLocation == null || _destination == null) return;
    final url = Uri.parse(
        "http://router.project-osrm.org/route/v1/driving/${_currentLocation!.longitude},${_currentLocation!.latitude};${_destination!.longitude},${_destination!.latitude}?overview=full&geometries=polyline");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      _decodePolyline(json.decode(response.body)['routes'][0]['geometry']);
    } else {
      _showErrorMessage("Tìm kiếm tuyến đường thất bại.");
    }
  }

  Future<void> _fetchStopStations() async {
    final url = Uri.parse("$apiUrl/get-stop-stations");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        _stopStations = List<LatLng>.from(json
            .decode(response.body)
            .map((item) => LatLng(item['lat'], item['lon'])));
      });
    } else {
      _showErrorMessage("Không thể lấy danh sách trạm dừng.");
    }
  }

  Future<void> getReturnRoute(String routeId) async {
    final url = Uri.parse("$apiUrl/get-return-route/$routeId");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      _decodePolyline(json.decode(response.body)['route']['geometry']);
    } else {
      _showErrorMessage("Không thể lấy tuyến đường về.");
    }
  }

  void _decodePolyline(String encodedPolyline) {
    setState(() {
      _route = PolylinePoints()
          .decodePolyline(encodedPolyline)
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();
    });
  }

  Future<bool> _checkPermissions() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return false;
    }
    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return false;
    }
    return true;
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
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
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.thunderforest.com/atlas/{z}/{x}/{y}.png?apikey=813ea228575b4ccfb96ba6960bb9fb94',
                    ),
                    CurrentLocationLayer(),
                    if (_stopStations.isNotEmpty)
                      MarkerLayer(
                        markers: _stopStations
                            .map((station) => Marker(
                                  point: station,
                                  width: 40,
                                  height: 40,
                                  child: const Icon(Icons.directions_bus,
                                      size: 30, color: Colors.green),
                                ))
                            .toList(),
                      ),
                  ],
                ),
        ],
      ),
    );
  }
}
