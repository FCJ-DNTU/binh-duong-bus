import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                'assets/images/Logo.jpg',
                width: 250,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 40),

            // Tiêu đề "Đăng Nhập"
            const Text(
              'Đăng Nhập',
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 35),

            // Email Input
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'xoandev@gmail.com',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),

            const SizedBox(height: 15),

            // Password Input
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Mật khẩu',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 50),

            // Đăng Nhập Button
            ElevatedButton(
              onPressed: () {
                // Xử lý logic khi đăng nhập
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                backgroundColor: Colors.blue,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Đăng nhập',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 30),

            // Đăng nhập với Google và Facebook
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Đăng nhập với ',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(width: 10),
                // Biểu tượng Google
                GestureDetector(
                  onTap: () {
                    // Đăng nhập bằng Google
                  },
                  child: Image.asset(
                    'assets/images/google.png',
                    width: 30,
                    height: 30,
                  ),
                ),
                const SizedBox(width: 13),
                // Biểu tượng Facebook
                GestureDetector(
                  onTap: () {
                    // Đăng nhập bằng Facebook
                  },
                  child: Image.asset(
                    'assets/images/facebook.png',
                    width: 30,
                    height: 30,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Đăng ký tài khoản
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Bạn chưa có tài khoản? '),
                SizedBox(width: 5),
                GestureDetector(
                  onTap: () {
                    // Điều hướng tới trang đăng ký
                  },
                  child: const Text(
                    'Đăng Ký',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
