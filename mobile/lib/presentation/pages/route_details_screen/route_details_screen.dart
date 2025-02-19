import 'package:binhduongbus/data/sources/remote/bus_api.dart';
import 'package:flutter/material.dart';
import 'package:binhduongbus/data/models/bus_route_model.dart'; 

class RouteDetailScreen extends StatefulWidget {
  final String routeId;
  final String title;
  final List<TimeLine> timelines;

  const RouteDetailScreen({
    Key? key,
    required this.routeId,
    required this.title,
    required this.timelines,
  }) : super(key: key);

  @override
  _RouteDetailScreenState createState() => _RouteDetailScreenState();
}

class _RouteDetailScreenState extends State<RouteDetailScreen> {
  bool isGoingRoute = true;
  late Future<BusRoute> routeDetails;

  @override
  void initState() {
    super.initState();
    routeDetails = BusApi().getRouteDetails(widget.routeId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.title} - Chi tiết tuyến xe'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FutureBuilder<BusRoute>(
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
                  : route.routeStops.reversed
                      .map((stop) => stop.stopName)
                      .toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.directions_bus,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          route.routeName,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => setState(() => isGoingRoute = true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isGoingRoute
                                ? Colors.blue
                                : Colors.grey.shade200,
                            foregroundColor:
                                isGoingRoute ? Colors.white : Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('Xem lượt đi',
                              style: TextStyle(fontSize: 16)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => setState(() => isGoingRoute = false),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isGoingRoute
                                ? Colors.grey.shade200
                                : Colors.blue,
                            foregroundColor:
                                isGoingRoute ? Colors.black : Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('Xem lượt về',
                              style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  DefaultTabController(
                    length: 3,
                    child: Column(
                      children: [
                        const TabBar(
                          tabs: [
                            Tab(text: 'Biểu đồ giờ'),
                            Tab(text: 'Trạm dừng'),
                            Tab(text: 'Thông tin'),
                          ],
                          indicatorColor: Colors.blue,
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
      ),
    );
  }

  Widget _buildSchedule() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: widget.timelines.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Center(
            child: Text(
              widget.timelines[index]
                  .departureTime,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            if (!isFirst)
              Container(width: 2, height: 10, color: Colors.grey.shade400),
            Icon(
              Icons.circle,
              color: (isFirst || isLast) ? Colors.blue : Colors.grey.shade400,
              size: 12,
            ),
            if (!isLast)
              Container(width: 2, height: 10, color: Colors.grey.shade400),
          ],
        ),
        const SizedBox(width: 20),
        Text(stops[index], style: const TextStyle(fontSize: 16)),
      ],
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
          Wrap(
            spacing: 8.0,
            runSpacing: 5.0,
            children: [
              Row(
                children: [
                  const Icon(Icons.monetization_on, color: Colors.blue),
                  const SizedBox(width: 8),
                  Text('Giá vé: ${route.routePrice} VND',
                      style: const TextStyle(fontSize: 16)),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.timelapse, color: Colors.blue),
                  const SizedBox(width: 8),
                  Text('Thời gian chạy: ${route.startTime} - ${route.endTime}',
                      style: const TextStyle(fontSize: 16)),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.directions_walk, color: Colors.blue),
                  const SizedBox(width: 8),
                  const Text('Độ dài tuyến: 10 km',
                      style: TextStyle(fontSize: 16)),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.schedule, color: Colors.blue),
                  const SizedBox(width: 8),
                  const Text('Giãn cách tuyến: 29 phút',
                      style: TextStyle(fontSize: 16)),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.domain, color: Colors.blue),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Đơn vị: Công ty TNHH MTV Xe khách Bình Dương',
                      style: const TextStyle(fontSize: 16),
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
