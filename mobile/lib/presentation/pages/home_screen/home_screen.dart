import 'package:flutter/material.dart';
import 'package:binhduongbus/data/sources/remote/bus_api.dart';
import 'package:binhduongbus/data/models/bus_route_model.dart';
import 'package:binhduongbus/presentation/pages/route_details_screen/route_details_screen.dart';
import 'package:binhduongbus/presentation/pages/route_planning_screen/route_planning_screen.dart';
import 'package:binhduongbus/presentation/pages/setting_screen/setting_screen.dart';
import 'package:binhduongbus/core/config/app_theme.dart';

class RouteSearchScreen extends StatefulWidget {
  const RouteSearchScreen({Key? key}) : super(key: key);

  @override
  _RouteSearchScreenState createState() => _RouteSearchScreenState();
}

class _RouteSearchScreenState extends State<RouteSearchScreen> {
  int _selectedTabIndex = 0;
  List<BusRoute> _allRoutes = [];
  List<BusRoute> _filteredRoutes = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadBusRoutes();
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> _loadBusRoutes() async {
    try {
      List<BusRoute> routes = await BusApi().getBusRoutes();
      setState(() {
        _allRoutes = routes;
        _filteredRoutes = routes;
      });
    } catch (e) {
      print('Lỗi khi tải tuyến xe: $e');
    }
  }

  void _onSearchChanged() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredRoutes = _allRoutes
          .where((route) =>
              route.routeName.toLowerCase().contains(query) ||
              route.routeNumber.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.primaryColor,
          leading: Image.asset(
            'assets/images/Icon_Logo.png',
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
          title: const Text(
            'Bình Dương Bus',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.white, size: 30.0),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingScreen()),
                );
              },
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50.0),
            child: Container(
              color: Colors.white,
              child: TabBar(
                onTap: (index) {
                  setState(() {
                    _selectedTabIndex = index;
                  });
                },
                tabs: const [
                  Tab(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search, size: 20),
                        SizedBox(width: 8.0),
                        Text('TRA CỨU'),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.map, size: 20),
                        SizedBox(width: 8.0),
                        Text('TÌM ĐƯỜNG'),
                      ],
                    ),
                  ),
                ],
                labelColor: Colors.blue,
                indicatorColor: Colors.blue,
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (_selectedTabIndex == 0)
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Nhập tuyến đường cần tìm',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              Expanded(
                child: TabBarView(
                  children: [
                    RouteList(filteredRoutes: _filteredRoutes),
                    RoutePlanningScreen(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }
}

class RouteList extends StatelessWidget {
  final List<BusRoute> filteredRoutes;

  const RouteList({Key? key, required this.filteredRoutes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (filteredRoutes.isEmpty) {
      return const Center(child: Text('Không có tuyến đường nào phù hợp'));
    }

    return ListView.builder(
      itemCount: filteredRoutes.length,
      itemBuilder: (context, index) {
        return RouteCard(
          routeDetails: 'Tuyến ${filteredRoutes[index].routeNumber}',
          title: filteredRoutes[index].routeName,
          time:
              '${filteredRoutes[index].startTime} - ${filteredRoutes[index].endTime}',
          price: '${filteredRoutes[index].routePrice} VND',
          routeId: filteredRoutes[index].id,
        );
      },
    );
  }
}

class RouteCard extends StatelessWidget {
  final String title;
  final String routeDetails;
  final String time;
  final String price;
  final String routeId;

  const RouteCard({
    Key? key,
    required this.routeDetails,
    required this.title,
    required this.time,
    required this.price,
    required this.routeId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 7.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: const Color(0xFFEBF0F5),
      elevation: 4.0,
      child: ListTile(
        contentPadding: const EdgeInsets.all(7.0),
        leading: const Icon(Icons.directions_bus,
            size: 40, color: Color(0xFF2882E2)),
        title: Text(
          title,
          style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2882E2)),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4.0),
            Text(routeDetails,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 20),
                    const SizedBox(width: 8.0),
                    Text(time)
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.attach_money, size: 20),
                    Text(price)
                  ],
                ),
              ],
            )
          ],
        ),
        onTap: () async {
          List<TimeLine> timelines =
              await BusApi().getTimelinesForRoute(routeId);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RouteDetailScreen(
                  routeId: routeId, title: title, timelines: timelines),
            ),
          );
        },
      ),
    );
  }
}
