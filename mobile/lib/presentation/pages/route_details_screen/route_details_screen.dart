import 'package:flutter/material.dart';
import 'package:binhduongbus/data/sources/remote/bus_api.dart';
import 'package:binhduongbus/data/models/bus_route_model.dart';
import 'package:intl/intl.dart';

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
        bool isCurrent =
            now.hour == scheduleTime.hour && now.minute == scheduleTime.minute;

        return Container(
          padding: isCurrent ? const EdgeInsets.all(2.0) : null,
          decoration: BoxDecoration(
            color: isPast ? Colors.grey.shade300 : Colors.blue.shade400,
            borderRadius: BorderRadius.circular(isCurrent ? 4 : 8),
            border: Border.all(
                color: isPast ? Colors.grey.shade500 : Colors.blue.shade200),
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

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 20,
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
        ),
        const SizedBox(width: 10),
        Align(
          alignment: Alignment.centerLeft, 
          child: Text(
            stops[index],
            style: const TextStyle(fontSize: 16),
          ),
        ),
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
          Text('Giá vé: ${route.routePrice} VND',
              style: const TextStyle(fontSize: 16)),
          Text('Thời gian chạy: ${route.startTime} - ${route.endTime}',
              style: const TextStyle(fontSize: 16)),
          const Text('Độ dài tuyến: 10 km', style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
