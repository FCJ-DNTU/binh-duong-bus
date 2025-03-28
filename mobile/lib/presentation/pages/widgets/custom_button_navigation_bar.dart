import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      elevation: 10,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              icon: Icons.map,
              index: 0,
              context: context,
            ),
            _buildNavItem(
              icon: Icons.directions_bus,
              index: 1,
              context: context,
            ),
            _buildHomeButton(context),
            _buildNavItem(
              icon: Icons.person_outline,
              index: 3,
              context: context,
            ),
            _buildNavItem(
              icon: Icons.settings_outlined,
              index: 4,
              context: context,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required int index,
    required BuildContext context,
  }) {
    bool isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.blue : Colors.grey,
            size: 24,
          ),
        ],
      ),
    );
  }

  Widget _buildHomeButton(BuildContext context) {
    bool isSelected = currentIndex == 2;
    return GestureDetector(
      onTap: () => onTap(2),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.transparent,
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(8),
        child: Icon(
          Icons.home,
          color: isSelected ? Colors.blue : Colors.grey,
          size: 28,
        ),
      ),
    );
  }
}

// Example Usage in a StatefulWidget
class ExamplePage extends StatefulWidget {
  const ExamplePage({super.key});

  @override
  _ExamplePageState createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  int _currentIndex = 2; // Default to home

  final List<Widget> _pages = [
    // Add your page widgets here
    const Placeholder(color: Colors.red),
    const Placeholder(color: Colors.green),
    const Placeholder(color: Colors.blue),
    const Placeholder(color: Colors.yellow),
    const Placeholder(color: Colors.purple),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
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
}