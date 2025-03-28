import 'package:flutter/material.dart';
import 'package:binhduongbus/core/config/app_routes.dart';

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
      onTap: () => _onItemTapped(index, context),
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
      onTap: () => _onItemTapped(2, context),
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

  void _onItemTapped(int index, BuildContext context) {
    onTap(index);
    _navigateTo(index, context);
  }

  void _navigateTo(int index, BuildContext context) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, AppRoutes.routePlanning);
        break;
      case 1:
        Navigator.pushNamed(context, AppRoutes.routes);
        break;
      case 2:
        Navigator.pushNamed(context, AppRoutes.home);
        break;
      case 3:
        Navigator.pushNamed(context, AppRoutes.notification);
        break;
      case 4:
        Navigator.pushNamed(context, AppRoutes.settings);
        break;
    }
  }
}
