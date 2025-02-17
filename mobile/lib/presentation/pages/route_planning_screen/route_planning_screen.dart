import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class RoutePlanningScreen extends StatefulWidget {
  const RoutePlanningScreen({Key? key}) : super(key: key);

  @override
  _RoutePlanningScreenState createState() => _RoutePlanningScreenState();
}

class _RoutePlanningScreenState extends State<RoutePlanningScreen> {
  final TextEditingController _startLocationController =
      TextEditingController();
  final TextEditingController _endLocationController = TextEditingController();

  // Hàm hoán đổi vị trí giữa điểm xuất phát và điểm đến
  void _swapLocations() {
    String temp = _startLocationController.text;
    _startLocationController.text = _endLocationController.text;
    _endLocationController.text = temp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 2.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _startLocationController,
                        decoration: InputDecoration(
                          hintText: 'Chọn điểm xuất phát',
                          prefixIcon:
                              const Icon(Icons.location_on, color: Colors.blue),
                          filled: true,
                          fillColor: Colors.grey.shade200,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _endLocationController,
                        decoration: InputDecoration(
                          hintText: 'Chọn điểm kết thúc',
                          prefixIcon:
                              const Icon(Icons.flag, color: Colors.blue),
                          filled: true,
                          fillColor: Colors.grey.shade200,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                // Nút hoán đổi
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.swap_vert,
                        color: Colors.blue, size: 30),
                    onPressed: _swapLocations,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(10.879362, 106.814213),
                initialZoom: 15,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                RichAttributionWidget(
                  attributions: [
                    TextSourceAttribution(
                      'OpenStreetMap contributors',
                      onTap: () => launchUrl(
                        Uri.parse('https://openstreetmap.org/copyright'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
