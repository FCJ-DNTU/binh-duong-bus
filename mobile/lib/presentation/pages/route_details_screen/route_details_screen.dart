import 'package:binhduongbus/data/models/bus_route_model.dart';
import 'package:binhduongbus/data/sources/remote/bus_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class RouteDetailScreen extends StatefulWidget {
  final String routeId;
  final String title;
  final List<TimeLine> timelines;
  final int intervalMinutes;

  const RouteDetailScreen({
    Key? key,
    required this.routeId,
    required this.title,
    required this.timelines,
    required this.intervalMinutes,
  }) : super(key: key);

  @override
  _RouteDetailScreenState createState() => _RouteDetailScreenState();
}

class _RouteDetailScreenState extends State<RouteDetailScreen> {
  bool isGoingRoute = true;
  late Future<BusRoute> routeDetails;
  List<List<LatLng>> segments = [];
  List<LatLng> stopPoints = [];
  bool isLoading = true;
  String? error;
  final DraggableScrollableController _scrollController = DraggableScrollableController();
  double _sheetPosition = 0.15; // Initial position (just showing route summary)

  @override
  void initState() {
    super.initState();
    routeDetails = BusApi().getRouteDetails(widget.routeId);
    fetchRouteData();
  }

  Future<void> fetchRouteData() async {
    final String apiUrl = dotenv.env['API_URL'] ?? '';
    try {
      final response = await http.get(Uri.parse('$apiUrl/api/routes/${widget.routeId}'));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final data = jsonResponse['data'];

        // Create multiple polylines instead of one big polyline
        List<List<LatLng>> routeSegments = [];

        if (data['ways'] != null) {
          for (var way in data['ways']) {
            if (way['geometry'] != null &&
                way['geometry']['type'] == 'LineString' &&
                way['geometry']['coordinates'] != null) {
              final List coordinates = way['geometry']['coordinates'];
              List<LatLng> segmentPoints = [];

              for (int i = 0; i < coordinates.length; i++) {
                LatLng point = LatLng(coordinates[i][1], coordinates[i][0]);

                if (segmentPoints.isEmpty || segmentPoints.last != point) {
                  segmentPoints.add(point);
                }
              }

              if (segmentPoints.isNotEmpty) {
                routeSegments.add(segmentPoints);
              }
            }
          }
        }

        // Extract stop points
        final List<LatLng> extractedStopPoints = [];
        if (data['stops'] != null) {
          for (var stop in data['stops']) {
            if (stop['location'] != null &&
                stop['location']['latitude'] != null &&
                stop['location']['longitude'] != null) {
              final double lat = stop['location']['latitude'];
              final double lng = stop['location']['longitude'];
              extractedStopPoints.add(LatLng(lat, lng));
            }
          }
        }

        setState(() {
          segments = routeSegments;
          stopPoints = extractedStopPoints;
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Failed to load route data: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error fetching route data: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Map Layer
          _buildMapLayer(),

          // Back Button
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(Icons.arrow_back, color: Colors.black),
              ),
            ),
          ),

          // Bottom Draggable Sheet
          DraggableScrollableSheet(
            initialChildSize: _sheetPosition,
            minChildSize: 0.15, // Minimum height (route summary)
            maxChildSize: 0.8, // Maximum height (full details)
            controller: _scrollController,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Drag handle
                    Container(
                      margin: EdgeInsets.only(top: 12, bottom: 8),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),

                    // Content
                    Expanded(
                      child: ListView(
                        controller: scrollController,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        children: [
                          _buildRouteSummary(),
                          const SizedBox(height: 24),
                          FutureBuilder<BusRoute>(
                            future: routeDetails,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(child: Text('Lỗi: ${snapshot.error}'));
                              } else if (!snapshot.hasData) {
                                return const Center(child: Text('Không có dữ liệu tuyến xe'));
                              } else {
                                BusRoute route = snapshot.data!;
                                List<String> stops = isGoingRoute
                                    ? route.routeStops.map((stop) => stop.stopName).toList()
                                    : route.routeStops.reversed.map((stop) => stop.stopName).toList();

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () => setState(() => isGoingRoute = true),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: isGoingRoute ? Color(0xFF007AFF) : Colors.grey.shade200,
                                              foregroundColor: isGoingRoute ? Colors.white : Colors.black,
                                              padding: const EdgeInsets.symmetric(vertical: 16),
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                            ),
                                            child: const Text('Xem lượt đi', style: TextStyle(fontSize: 16)),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () => setState(() => isGoingRoute = false),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: isGoingRoute ? Colors.grey.shade200 : Color(0xFF007AFF),
                                              foregroundColor: isGoingRoute ? Colors.black : Colors.white,
                                              padding: const EdgeInsets.symmetric(vertical: 16),
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                            ),
                                            child: const Text('Xem lượt về', style: TextStyle(fontSize: 16)),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    DefaultTabController(
                                      length: 3,
                                      child: Column(
                                        children: [
                                          TabBar(
                                            tabs: const [
                                              Tab(text: 'Biểu đồ giờ'),
                                              Tab(text: 'Trạm dừng'),
                                              Tab(text: 'Thông tin'),
                                            ],
                                            indicatorColor: Color(0xFF007AFF),
                                            labelColor: Color(0xFF007AFF),
                                            unselectedLabelColor: Colors.grey.shade700,
                                          ),
                                          const SizedBox(height: 16),
                                          SizedBox(
                                            height: 400,
                                            child: TabBarView(
                                              children: [
                                                _buildSchedule(),
                                                _buildStopsList(stops),
                                                _buildRouteInfo(route),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMapLayer() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator(color: Color(0xFF007AFF)));
    } else if (error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: 48),
              SizedBox(height: 16),
              Text(
                'Error Loading Route',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(error!, textAlign: TextAlign.center),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isLoading = true;
                    error = null;
                  });
                  fetchRouteData();
                },
                child: Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF007AFF),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return FlutterMap(
        options: MapOptions(
          initialCenter: stopPoints.isNotEmpty
              ? stopPoints.first
              : LatLng(10.0, 106.0),
          initialZoom: 15,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          PolylineLayer(
            polylines: segments
                .map((points) => Polyline(
              points: points,
              color: Color(0xFF007AFF),
              strokeWidth: 4.0,
            ))
                .toList(),
          ),
          MarkerLayer(
            markers: stopPoints
                .map((stop) => Marker(
              point: stop,
              width: 42,
              height: 42,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.directions_bus,
                    color: Color(0xFF007AFF),
                    size: 24,
                  ),
                ),
              ),
            ))
                .toList(),
          ),
        ],
      );
    }
  }

  Widget _buildRouteSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xFFEEF3FC),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.directions_bus,
                color: Color(0xFF007AFF),
                size: 24,
              ),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.title,
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.black)),
                Text("${stopPoints.length} stops",
                    style: TextStyle(fontSize: 13, color: Colors.grey[600])),
              ],
            ),
            Spacer(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Color(0xFF007AFF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text("GO",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14)),
            ),
          ],
        ),
        SizedBox(height: 12),
        Text("Khởi hành mỗi ${widget.intervalMinutes} phút",
            style: TextStyle(fontSize: 13, color: Colors.grey[600])),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: Color(0xFFF8F8F8),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.schedule, size: 16, color: Colors.grey[700]),
              SizedBox(width: 8),
              Text(
                "Chuyến tiếp theo: 10 phút nữa",
                style: TextStyle(color: Colors.grey[800], fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSchedule() {
    DateTime now = DateTime.now();
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        crossAxisSpacing: 6.0,
        mainAxisSpacing: 6.0,
        childAspectRatio: 1.5,
      ),
      itemCount: widget.timelines.length,
      itemBuilder: (context, index) {
        String departureTime = widget.timelines[index].departureTime;
        DateTime scheduleTime = DateFormat('HH:mm').parse(departureTime);
        bool isPast = now.hour > scheduleTime.hour ||
            (now.hour == scheduleTime.hour && now.minute > scheduleTime.minute);
        bool isCurrent = now.hour == scheduleTime.hour && now.minute == scheduleTime.minute;

        return Container(
          padding: isCurrent ? const EdgeInsets.all(2.0) : null,
          decoration: BoxDecoration(
            color: isPast ? Colors.grey.shade300 : Color(0xFF007AFF),
            borderRadius: BorderRadius.circular(isCurrent ? 4 : 8),
            border: Border.all(color: isPast ? Colors.grey.shade500 : Color(0xFF005BBF)),
          ),
          child: Center(
            child: Text(
              departureTime,
              style: TextStyle(
                fontSize: isCurrent ? 12 : 14,
                fontWeight: FontWeight.bold,
                color: isPast ? Colors.grey.shade600 : Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStopsList(List<String> stops) {
    return ListView.builder(
      itemCount: stops.length,
      itemBuilder: (context, index) => _buildStopItem(index, stops),
    );
  }

  Widget _buildStopItem(int index, List<String> stops) {
    bool isFirst = index == 0;
    bool isLast = index == stops.length - 1;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 20,
            child: Column(
              children: [
                if (!isFirst) Container(width: 2, height: 20, color: Colors.grey.shade400),
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: (isFirst || isLast) ? Color(0xFF007AFF) : Colors.white,
                    border: Border.all(
                      color: (isFirst || isLast) ? Color(0xFF007AFF) : Colors.grey.shade400,
                      width: 2,
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
                if (!isLast) Container(width: 2, height: 20, color: Colors.grey.shade400),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stops[index],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: (isFirst || isLast) ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                if (isFirst || isLast)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      isFirst ? 'Điểm đầu' : 'Điểm cuối',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF007AFF),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteInfo(BusRoute route) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Thông tin tuyến xe',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildInfoItem(Icons.payments, 'Giá vé', '${route.routePrice} VND'),
          _buildInfoItem(Icons.access_time, 'Thời gian chạy', '${route.startTime} - ${route.endTime}'),
          _buildInfoItem(Icons.straighten, 'Độ dài tuyến', '10 km'),
          _buildInfoItem(Icons.schedule, 'Tần suất', 'Mỗi ${widget.intervalMinutes} phút'),
          _buildInfoItem(Icons.calendar_today, 'Ngày hoạt động', 'Thứ 2 - Chủ nhật'),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mô tả tuyến',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Tuyến xe buýt này kết nối các khu vực chính của thành phố, bao gồm trung tâm, khu đại học và các khu dân cư phía Đông.',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFFEEF3FC),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Color(0xFF007AFF), size: 20),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}