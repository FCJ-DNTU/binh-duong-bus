import 'package:binhduongbus/data/models/bus_route_model.dart';
import 'package:binhduongbus/data/sources/remote/bus_api.dart';
import 'package:binhduongbus/presentation/pages/route_details_screen/route_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteRoutesScreen extends StatefulWidget {
  const FavoriteRoutesScreen({Key? key}) : super(key: key);

  @override
  _FavoriteRoutesScreenState createState() => _FavoriteRoutesScreenState();
}

class _FavoriteRoutesScreenState extends State<FavoriteRoutesScreen> {
  List<BusRoute> _favoriteRoutes = [];
  Set<String> _favoriteRouteIds = {};

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIds = prefs.getStringList('favorite_routes')?.toSet() ?? {};
    List<BusRoute> allRoutes = await BusApi().getBusRoutes();
    setState(() {
      _favoriteRouteIds = favoriteIds;
      _favoriteRoutes =
          allRoutes.where((route) => favoriteIds.contains(route.id)).toList();
    });
  }

  Future<void> _toggleFavorite(String routeId) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (_favoriteRouteIds.contains(routeId)) {
        _favoriteRouteIds.remove(routeId);
        _favoriteRoutes.removeWhere((route) => route.id == routeId);
      }
    });
    await prefs.setStringList('favorite_routes', _favoriteRouteIds.toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 40,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black, size: 24),
            padding: EdgeInsets.zero,
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: const Text(
          'Tuyến đường yêu thích',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: _favoriteRoutes.isEmpty
          ? const Center(child: Text('Chưa có tuyến đường yêu thích nào'))
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              itemCount: _favoriteRoutes.length,
              separatorBuilder: (context, index) => const Divider(
                height: 1,
                thickness: 1,
                color: Color(0xFFEEEEEE),
              ),
              itemBuilder: (context, index) {
                return FavoriteRouteCard(
                  route: _favoriteRoutes[index],
                  onRemove: () => _toggleFavorite(_favoriteRoutes[index].id),
                );
              },
            ),
    );
  }
}

class FavoriteRouteCard extends StatelessWidget {
  final BusRoute route;
  final VoidCallback onRemove;

  const FavoriteRouteCard({
    Key? key,
    required this.route,
    required this.onRemove,
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
        padding: const EdgeInsets.symmetric(vertical: 10),
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
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
            const SizedBox(width: 12),
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
                  const SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '${route.routePrice} VND',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF495057),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: onRemove,
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF6C757D),
                                  width: 1,
                                ),
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Color(0xFF6C757D),
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
