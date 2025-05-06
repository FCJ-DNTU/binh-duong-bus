import 'package:binhduongbus/core/config/app_routes.dart';
import 'package:binhduongbus/presentation/pages/widgets/custom_button_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:binhduongbus/presentation/pages/event_screen/event_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 2;

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> events = [
      {
        'title': 'Giảm giá lên đến 50% khi thanh toán bằng thẻ tín dụng',
        'date': 'March 29, 2025',
        'image': 'assets/images/banner_event_1.JPG',
      },
      {
        'title': 'Khuyến mãi đặc biệt cho sinh viên',
        'date': 'April 1, 2025',
        'image': 'assets/images/banner_event_1.JPG',
      },
      {
        'title': 'Khuyến mãi đặc biệt cho sinh viên',
        'date': 'April 1, 2025',
        'image': 'assets/images/banner_event_1.JPG',
      },
      {
        'title': 'Khuyến mãi đặc biệt cho sinh viên',
        'date': 'April 1, 2025',
        'image': 'assets/images/banner_event_1.JPG',
      },
    ];

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 200,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 8.0),
                  child: Image.asset(
                    'assets/images/banner.jpeg',
                    fit: BoxFit.contain,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Card(
                    color: Colors.white,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          _buildQuickAccessItem(Icons.map, "Bản đồ",
                              AppRoutes.routePlanning, Colors.blue),
                          _buildQuickAccessItem(Icons.directions_bus,
                              "Tuyến xe", AppRoutes.routes, Colors.red),
                          _buildQuickAccessItem(Icons.person, "Tài khoản",
                              AppRoutes.settings, Colors.green),
                          _buildQuickAccessItem(Icons.info, "Giới thiệu",
                              AppRoutes.settings, Colors.orange),
                          _buildQuickAccessItem(Icons.event, "Sự kiện",
                              AppRoutes.eventList, Colors.purple),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    "Gần đây",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                _buildRecentRoute(
                  "KCN Mỹ Phước - Bến xe Lam Hồng",
                  "Tuyến D1",
                  "09:25 - 16:57",
                  "10.000 VNĐ",
                ),
                _buildRecentRoute(
                  "Bình Mỹ (Củ Chi) - Thủ Dầu Một",
                  "Tuyến D2",
                  "09:25 - 16:57",
                  "6.000 VNĐ",
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    "Tin tức",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                SizedBox(
                  height: 260,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index];
                      return Container(
                        width: 220,
                        margin: const EdgeInsets.only(right: 16.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 4,
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, AppRoutes.eventDetail);
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(15),
                                  ),
                                  child: Image.asset(
                                    event['image']!,
                                    height: 140,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        height: 140,
                                        color: Colors.grey[300],
                                        child: const Center(
                                          child: Icon(
                                            Icons.broken_image,
                                            color: Colors.grey,
                                            size: 40,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        event['title']!,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.calendar_today,
                                            size: 14,
                                            color: Colors.grey[600],
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            event['date']!,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          Positioned(
            bottom: 30,
            right: 16,
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/chat');
              },
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/images/avatar_chat.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
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

  Widget _buildQuickAccessItem(
      IconData icon, String label, String path, Color iconColor) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, path);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 30,
              color: iconColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
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
        elevation: 2,
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRoutes.payment,
              arguments: {
                'routeName': title,
                'routeNumber': route.replaceAll('Tuyến ', ''),
                'dateTime': time,
                'price': price.replaceAll(' VNĐ', ''),
              },
            );
          },
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.directions_bus,
                color: Colors.blue,
                size: 30,
              ),
            ),
            title: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  route,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          time,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.attach_money,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          price,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
