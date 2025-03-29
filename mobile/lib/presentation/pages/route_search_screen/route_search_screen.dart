import 'package:binhduongbus/core/config/app_routes.dart';
import 'package:binhduongbus/presentation/pages/widgets/custom_button_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:binhduongbus/data/sources/remote/bus_api.dart';
import 'package:binhduongbus/data/models/bus_route_model.dart';
import 'package:binhduongbus/presentation/pages/route_details_screen/route_details_screen.dart';
import 'package:binhduongbus/core/config/app_theme.dart';

class RouteSearchScreen extends StatefulWidget {
  const RouteSearchScreen({Key? key}) : super(key: key);

  @override
  _RouteSearchScreenState createState() => _RouteSearchScreenState();
}

class _RouteSearchScreenState extends State<RouteSearchScreen> {
  int _currentIndex = 1;
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
      print('Error loading routes: $e');
    }
  }

  void _onSearchChanged() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredRoutes = _allRoutes.where((route) =>
      route.routeName.toLowerCase().contains(query) ||
          route.routeNumber.toLowerCase().contains(query)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),

      ),
      body: Column(
        children: [
          Expanded(
            child: _filteredRoutes.isEmpty
                ? const Center(child: Text('Không có tuyến đường nào phù hợp'))
                : ListView.builder(
              itemCount: _filteredRoutes.length,
              itemBuilder: (context, index) {
                return RouteCard(route: _filteredRoutes[index]);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
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

class RouteCard extends StatelessWidget {
  final BusRoute route;

  const RouteCard({Key? key, required this.route}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white, // Added white background color
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.directions_bus, color: Colors.blue),
        ),
        title: Text(route.routeName, style: const TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tuyến ${route.routeNumber}',
                style: const TextStyle(color: Colors.grey)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text('${route.startTime} - ${route.endTime}')
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.attach_money, size: 16, color: Colors.grey),
                    Text('${route.routePrice} VND')
                  ],
                ),
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.favorite_border),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RouteDetailScreen(routeId: route.id, title: route.routeName, intervalMinutes: route.intervalMinutes),
            ),
          );
        },
      ),
    );
  }
}
