import 'package:binhduongbus/core/config/app_routes.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              'Hồ sơ',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/Logo.jpg'),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bình Dương Bus',
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '+81 64546456',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // Code edit
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),
            _buildCard(
              context,
              Icons.notifications,
              'Thông báo',
              Colors.blue.shade50,
              () {
                Navigator.pushNamed(context, AppRoutes.notification);
              },
            ),
            const SizedBox(height: 10),
            _buildCard(
              context,
              Icons.search,
              'Tra cứu',
              Colors.blue.shade50,
              () {
                Navigator.pushNamed(context, AppRoutes.routeDetails);
              },
            ),
            const SizedBox(height: 10),
            _buildCard(
              context,
              Icons.directions,
              'Tìm đường',
              Colors.blue.shade50,
              () {
                Navigator.pushNamed(context, AppRoutes.routeDetails);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context,
    IconData icon,
    String title,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        leading: Icon(
          icon,
          size: 40,
          color: Colors.blue,
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        onTap: onTap,
      ),
    );
  }
}

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thông báo')),
      body: const Center(child: Text('Nội dung thông báo')),
    );
  }
}

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tra cứu')),
      body: const Center(child: Text('Nội dung tra cứu')),
    );
  }
}
