import 'package:binhduongbus/core/config/app_routes.dart';
import 'package:binhduongbus/presentation/pages/widgets/custom_button_navigation_bar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Bus Image
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/banner.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Quick Access Card
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                color: Colors.grey[100],
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 3,
                    children: [
                      _buildQuickAccessItem(Icons.map, "Bản đồ", AppRoutes.routePlanning),
                      _buildQuickAccessItem(Icons.directions_bus, "Tuyến xe", AppRoutes.routes),
                      _buildQuickAccessItem(Icons.person, "Tài khoản", AppRoutes.settings),
                      _buildQuickAccessItem(Icons.info, "Giới thiệu", AppRoutes.settings),
                      _buildQuickAccessItem(Icons.event, "Sự kiện", AppRoutes.settings),
                    ],
                  ),
                ),
              ),
            ),

            // Recent Routes Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text("Gần đây",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            _buildRecentRoute("KCN Mỹ Phước - Bến xe Lam Hồng", "Tuyến D1",
                "09:25 - 16:57", "10.000 VNĐ"),
            _buildRecentRoute("Bình Mỹ (Củ Chi) - Thủ Dầu Một", "Tuyến D2",
                "09:25 - 16:57", "6.000 VNĐ"),

            // News Section
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text("Tin tức",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Card(
              margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/tin_tuc_01.png'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(10)),
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(8.0),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Tin tức mới - 01',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),

      // Bottom Navigation Bar
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

  Widget _buildQuickAccessItem(IconData icon, String label, String path) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          path,
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 35, color: Colors.blue),
          SizedBox(height: 8),
          Text(label,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildRecentRoute(
      String title, String route, String time, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Colors.white,
        child: ListTile(
          leading: Icon(Icons.directions_bus, color: Colors.blue, size: 30),
          title: Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.access_time, size: 16),
                  SizedBox(width: 4),
                  Text(time,
                      style: TextStyle(fontSize: 14, color: Colors.black)),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.attach_money, size: 16),
                  SizedBox(width: 4),
                  Text(price,
                      style: TextStyle(fontSize: 14, color: Colors.black)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
