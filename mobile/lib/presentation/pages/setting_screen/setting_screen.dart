import 'package:flutter/material.dart';
import 'package:binhduongbus/presentation/pages/widgets/custom_button_navigation_bar.dart';
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
          Container(
            height: MediaQuery.of(context).size.height * 0.35,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/banner_profile.JPG'),
                fit: BoxFit.cover,
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0277BD),
                  Color(0xFF039BE5),
                ],
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.2),
                    Colors.black.withOpacity(0.5),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 24,
                ),
                onPressed: () {},
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Center(
                    child: Column(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 3,
                            ),
                          ),
                          child: const CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/images/Logo.jpg'),
                            radius: 48,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Binh Duong Bus',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                offset: Offset(0, 1),
                                blurRadius: 3.0,
                                color: Color.fromARGB(128, 0, 0, 0),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'binhduongbus@email.com',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            shadows: [
                              Shadow(
                                offset: Offset(0, 1),
                                blurRadius: 3.0,
                                color: Color.fromARGB(128, 0, 0, 0),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                      child: ListView(
                        children: [
                          _buildMenuItem(
                            Icons.notifications_outlined,
                            'Thông báo',
                            onTap: () {
                              Navigator.pushNamed(
                                  context, AppRoutes.notification);
                            },
                          ),
                          const SizedBox(height: 8),
                          _buildMenuItem(
                            Icons.map_outlined,
                            'Bản đồ',
                            onTap: () {
                              Navigator.pushNamed(
                                  context, AppRoutes.routePlanning);
                            },
                          ),
                          const SizedBox(height: 8),
                          _buildMenuItem(
                            Icons.route_outlined,
                            'Tuyến đường',
                            onTap: () {
                              Navigator.pushNamed(context, AppRoutes.routes);
                            },
                          ),
                          const SizedBox(height: 8),
                          _buildMenuItem(
                            Icons.search,
                            'Tìm đường',
                            onTap: () {
                              Navigator.pushNamed(context, AppRoutes.routes);
                            },
                          ),
                          const SizedBox(height: 8),
                          _buildMenuItem(
                            Icons.favorite,
                            'Tuyến đường yêu thích',
                            onTap: () {
                              Navigator.pushNamed(
                                  context, AppRoutes.favoriteRoutes);
                            },
                          ),

                          const SizedBox(height: 16),

                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFE5E5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 4),
                              leading: const Icon(
                                Icons.logout,
                                color: Colors.red,
                                size: 24,
                              ),
                              title: const Text(
                                'Đăng xuất',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                              trailing: const Icon(
                                Icons.chevron_right,
                                color: Colors.red,
                                size: 24,
                              ),
                              onTap: () {
                                Navigator.pushNamedAndRemoveUntil(
                                    context, AppRoutes.login, (route) => false);
                              },
                            ),
                          ),
                        ],
                      ),
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
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, AppRoutes.home);
              break;
            case 1:
              Navigator.pushReplacementNamed(context, AppRoutes.routes);
              break;
            case 2:
              Navigator.pushReplacementNamed(context, AppRoutes.routePlanning);
              break;
            case 4:
              break;
          }
        },
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String text, {VoidCallback? onTap}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Icon(
          icon,
          color: Colors.black87,
          size: 24,
        ),
        title: Text(
          text,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: Colors.black54,
          size: 24,
        ),
        onTap: onTap,
      ),
    );
  }
}
