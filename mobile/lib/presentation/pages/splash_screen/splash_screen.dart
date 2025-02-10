import 'package:flutter/material.dart';
import '../../../core/config/app_routes.dart';
import '../../../core/config/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Chuyển sang màn hình chính sau 3 giây
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor, // Màu nền lấy từ theme
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Tiêu đề ứng dụng
            const Text(
              'Bình Dương Bus',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 60),

            // Logo
            ClipRRect(
              borderRadius: BorderRadius.circular(20), // Bo viền 20px
              child: Image.asset(
                'assets/images/Logo.jpg',
                width: 260,
                height: 260,
                fit: BoxFit.cover, // Giữ tỉ lệ ảnh
              ),
            ),

            const SizedBox(height: 60),

            // Load
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),

            const SizedBox(height: 40),

            const Text(
              'Đang Khởi Động',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
