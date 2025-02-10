import 'package:flutter/material.dart';
import 'package:binhduongbus/core/config/app_theme.dart';

class RouteSearchScreen extends StatelessWidget {
  const RouteSearchScreen({Key? key}) : super(key: key);

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
                // Add menu
              },
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50.0),
            child: Container(
              color: Colors.white,
              child: const TabBar(
                tabs: [
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
              // Search input
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
              // TabBarView
              const Expanded(
                child: TabBarView(
                  children: [
                    // Content for "TRA CỨU" tab (search routes)
                    RouteList(),

                    // Content for "TÌM ĐƯỜNG" tab (route planning)
                    Center(
                      child: Text('Tìm Đường Content'),
                    ),
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
      children: [
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
        RouteCard(
          title: 'Tuyến D4',
          routeDetails: 'Thủ Dầu Một - Hội Nghĩa',
          time: '09:25 - 16:57',
          price: '20.000 VND',
        ),
        RouteCard(
          title: 'Tuyến D5',
          routeDetails: 'Bình Mỹ - Bến xe Bình Dương',
          time: '09:25 - 16:57',
          price: '15.000 VND',
        ),
        RouteCard(
          title: 'Tuyến D6',
          routeDetails: 'Toà nhà Becamex Tower - VSIP 2',
          time: '09:25 - 16:57',
          price: '10.000 VND',
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
      color: Color(0xFFEBF0F5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4.0,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        leading: const Icon(
          Icons.directions_bus,
          size: 40,
          color: Color.fromARGB(255, 108, 174, 202),
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
            Text(
              routeDetails,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, // Căn hai phần cách đều
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 20,
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      '$time',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.attach_money,
                      size: 20,
                    ),
                    Text(
                      '$price',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
