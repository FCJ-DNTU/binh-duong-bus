import 'package:flutter/material.dart';

class RouteDetailScreen extends StatefulWidget {
  final String title;

  const RouteDetailScreen({Key? key, required this.title}) : super(key: key);

  @override
  _RouteDetailScreenState createState() => _RouteDetailScreenState();
}

class _RouteDetailScreenState extends State<RouteDetailScreen> {
  bool isGoingRoute = true;

  final Map<String, List<String>> routeStops = {
    'Going': [
      'Bình Mỹ',
      'Cầu Phú Cường',
      'Đường Huỳnh Văn Cù',
      'Đường Cách Mạng Tháng 8',
      'Ngã Sáu',
      'Ngã ba Lò Chén',
      'Bến xe khách tỉnh Bình Dương',
    ],
    'Returning': [
      'Bến xe khách tỉnh Bình Dương',
      'Ngã ba Lò Chén',
      'Ngã Sáu',
      'Đường Cách Mạng Tháng 8',
      'Đường Huỳnh Văn Cù',
      'Cầu Phú Cường',
      'Bình Mỹ',
    ],
  };

  final List<String> scheduleGoing = [
    '5:00',
    '5:30',
    '6:00',
    '6:30',
    '7:00',
    '7:30',
    '8:00',
    '8:30',
    '9:00',
    '9:30',
    '10:00',
    '10:30',
    '11:00',
    '11:30',
    '12:00'
  ];

  final List<String> scheduleReturning = [
    '5:30',
    '6:00',
    '6:30',
    '7:00',
    '7:30',
    '8:00',
    '8:30',
    '9:00',
    '9:30',
    '10:00',
    '10:30',
    '11:00',
    '11:30',
    '12:00',
    '12:30'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.title} - Chi tiết tuyến xe',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.directions_bus, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  widget.title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
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
                      backgroundColor:
                          isGoingRoute ? Colors.blue : Colors.grey.shade200,
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
                      backgroundColor:
                          isGoingRoute ? Colors.grey.shade200 : Colors.blue,
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
                        _buildStopsList(
                            routeStops[isGoingRoute ? 'Going' : 'Returning']!),
                        _buildRouteInfo(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget hiển thị biểu đồ giờ
  Widget _buildSchedule() {
    List<String> selectedSchedule =
        isGoingRoute ? scheduleGoing : scheduleReturning;

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: selectedSchedule.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Center(
            child: Text(
              selectedSchedule[index],
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }

  // Widget hiển thị danh sách trạm dừng
  Widget _buildStopsList(List<String> stops) {
    return ListView.builder(
      itemCount: stops.length,
      itemBuilder: (context, index) => _buildStopItem(index, stops),
    );
  }

  // Widget hiển thị từng trạm dừng
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

  // Widget hiển thị thông tin chi tiết tuyến xe
  Widget _buildRouteInfo() {
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
                  const Text('Giá vé: 15.000 VND',
                      style: TextStyle(fontSize: 16)),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.timelapse, color: Colors.blue),
                  const SizedBox(width: 8),
                  const Text('Thời gian chạy: 5:00 - 5:30',
                      style: TextStyle(fontSize: 16)),
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
