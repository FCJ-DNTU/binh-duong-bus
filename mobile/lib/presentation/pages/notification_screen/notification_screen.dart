import 'package:flutter/material.dart';
import 'notification_detail_screen.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Thông báo',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildNotificationCard(
              context,
              Icons.directions_bus,
              'Khởi phục D2',
              'Từ 21/05 Bình Mỹ (Củ Chi) - cầu Phú Cường... Từ 07/08/2025',
            ),
            const SizedBox(height: 10),
            _buildNotificationCard(
              context,
              Icons.wb_sunny,
              'Xe bus hoạt động dịp lễ',
              'Thông báo kế hoạch nghỉ lễ hoạt động của tuyến xe bus...',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Card(
      color: Colors.blue.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4,
      child: ListTile(
        leading: Icon(
          icon,
          size: 40,
          color: Colors.blue,
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NotificationDetailScreen(
                title: title,
                subtitle: subtitle,
              ),
            ),
          );
        },
      ),
    );
  }
}
