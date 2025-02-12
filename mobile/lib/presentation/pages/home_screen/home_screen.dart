import 'package:binhduongbus/presentation/pages/route_details_screen/route_details_screen.dart';
import 'package:binhduongbus/presentation/pages/route_planning_screen/route_planning_screen.dart';
import 'package:binhduongbus/presentation/pages/setting_screen/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:binhduongbus/core/config/app_theme.dart';

class RouteSearchScreen extends StatefulWidget {
  const RouteSearchScreen({Key? key}) : super(key: key);

  @override
  _RouteSearchScreenState createState() => _RouteSearchScreenState();
}

class _RouteSearchScreenState extends State<RouteSearchScreen> {
  int _selectedTabIndex = 0;

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
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
                size: 30.0,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingScreen(),
                  ),
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
                        Icon(
                          Icons.map,
                          size: 20,
                        ),
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
                  decoration: InputDecoration(
                    hintText: 'Tìm tuyến xe',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              const Expanded(
                child: TabBarView(
                  children: [
                    RouteList(),
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
}

class RouteList extends StatelessWidget {
  const RouteList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        RouteCard(
          title: 'Tuyến D1',
          routeDetails: 'KCN Mỹ Phước - Bến xe Lam Hồng',
          time: '09:25 - 16:57',
          price: '10.000 VND',
        ),
        RouteCard(
          title: 'Tuyến D2',
          routeDetails: 'Bình Mỹ (Củ Chi) - Thủ Dầu Một',
          time: '09:25 - 16:57',
          price: '6.000 VND',
        ),
        RouteCard(
          title: 'Tuyến D3',
          routeDetails: 'Khu du lịch Đại Nam - Bến xe Miền Tây',
          time: '09:25 - 16:57',
          price: '15.000 VND',
        ),
      ],
    );
  }
}

class RouteCard extends StatelessWidget {
  final String title;
  final String routeDetails;
  final String time;
  final String price;

  const RouteCard({
    Key? key,
    required this.title,
    required this.routeDetails,
    required this.time,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: const Color(0xFFEBF0F5),
      elevation: 4.0,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        leading: const Icon(
          Icons.directions_bus,
          size: 40,
          color: Colors.blueAccent,
        ),
        title: Text(
          title,
          style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(routeDetails,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 20),
                    const SizedBox(width: 8.0),
                    Text(time),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.attach_money, size: 20),
                    Text(price),
                  ],
                ),
              ],
            )
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RouteDetailScreen(title: title),
            ),
          );
        },
      ),
    );
  }
}
