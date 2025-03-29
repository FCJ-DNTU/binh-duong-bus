import 'package:binhduongbus/presentation/pages/widgets/custom_button_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:binhduongbus/core/config/app_routes.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  int _currentIndex = 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background with gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF6A5AE0), // Purple gradient start
                  Color(0xFF8E7DFF), // Purple gradient end
                ],
              ),
            ),
          ),

          // Status bar spacer
          SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              alignment: Alignment.topRight,
              child: Icon(
                Icons.edit,
                color: Colors.white,
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Column(
              children: [
                // Profile Header
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 4,
                          ),
                        ),
                        child: CircleAvatar(
                          backgroundImage: AssetImage('assets/images/Logo.jpg'),
                          radius: 60,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Binh Duong Bus',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'binhduongbus@email.com',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 32),

                // Menu Items
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: ListView(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                      children: [
                        _buildMenuItem(
                            Icons.notifications_outlined, 'Thông báo'),
                        _buildMenuItem(Icons.map_outlined, 'Bản đồ'),
                        _buildMenuItem(Icons.route_outlined, 'Hành trình'),
                        _buildMenuItem(Icons.search, 'Tìm đường'),

                        SizedBox(height: 24),

                        // Logout Button
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFFFE5E5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: Icon(
                              Icons.logout,
                              color: Colors.red,
                            ),
                            title: Text(
                              'Đăng xuất',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Icon(
                              Icons.chevron_right,
                              color: Colors.red,
                            ),
                            onTap: () {
                              // Logout logic
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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

  Widget _buildMenuItem(IconData icon, String text) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      trailing: Icon(Icons.chevron_right),
      onTap: () {
        // Navigation logic
      },
    );
  }
}