import 'package:binhduongbus/core/config/app_routes.dart';
import 'package:binhduongbus/presentation/pages/widgets/custom_button_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:binhduongbus/data/sources/remote/bus_api.dart';
import 'package:binhduongbus/data/models/bus_route_model.dart';
import 'package:binhduongbus/presentation/pages/route_details_screen/route_details_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  Set<String> _favoriteRoutes = {};

  @override
  void initState() {
    super.initState();
    _loadBusRoutes();
    _loadFavorites();
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

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _favoriteRoutes = prefs.getStringList('favorite_routes')?.toSet() ?? {};
    });
  }

  Future<void> _toggleFavorite(String routeId) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (_favoriteRoutes.contains(routeId)) {
        _favoriteRoutes.remove(routeId);
      } else {
        _favoriteRoutes.add(routeId);
      }
    });
    await prefs.setStringList('favorite_routes', _favoriteRoutes.toList());
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

  void _navigateToHome() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.home,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D7FE3),
        elevation: 0,
        leadingWidth: 40,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
            padding: EdgeInsets.zero,
            onPressed: _navigateToHome,
          ),
        ),
        titleSpacing: 5,
        title: Container(
          height: 40,
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Nhập tuyến cần tìm',
              hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 11),
              isDense: true,
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
            child: const Text(
              'Danh sách tuyến',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF6C757D),
              ),
            ),
          ),
          Expanded(
            child: _filteredRoutes.isEmpty
                ? const Center(child: Text('Không có tuyến đường nào phù hợp'))
                : ListView.separated(
                    padding: const EdgeInsets.only(top: 4, bottom: 12),
                    itemCount: _filteredRoutes.length,
                    separatorBuilder: (context, index) => const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFEEEEEE),
                    ),
                    itemBuilder: (context, index) {
                      return RouteCard(
                        route: _filteredRoutes[index],
                        isFavorite:
                            _favoriteRoutes.contains(_filteredRoutes[index].id),
                        onFavoriteToggle: () =>
                            _toggleFavorite(_filteredRoutes[index].id),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index != _currentIndex) {
            if (index == 0) {
              _navigateToHome();
            } else {
              setState(() {
                _currentIndex = index;
              });
            }
          }
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
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const RouteCard({
    Key? key,
    required this.route,
    required this.isFavorite,
    required this.onFavoriteToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RouteDetailScreen(
              routeId: route.id,
              title: route.routeName,
              intervalMinutes: route.intervalMinutes,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 2),
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(
                Icons.directions_bus,
                color: Color(0xFF0D7FE3),
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    route.routeName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Color(0xFF212529),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Tuyến ${route.routeNumber}',
                    style: const TextStyle(
                      color: Color(0xFF6C757D),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 14,
                        color: Color(0xFF6C757D),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${route.startTime} - ${route.endTime}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF495057),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: onFavoriteToggle,
                  child: Container(
                    height: 26,
                    width: 26,
                    alignment: Alignment.center,
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : const Color(0xFF6C757D),
                      size: 22,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.monetization_on_outlined,
                      size: 14,
                      color: Color(0xFF6C757D),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${route.routePrice} VND',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF495057),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
