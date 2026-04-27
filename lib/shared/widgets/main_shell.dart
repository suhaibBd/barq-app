import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class MainShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Role-based: Post trip (driver) or Search (passenger)
          context.push('/search');
        },
        backgroundColor: AppColors.accent,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.add_rounded, size: 28, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        color: AppColors.surface,
        elevation: 8,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.home_rounded,
                label: 'الرئيسية',
                index: 0,
                currentIndex: navigationShell.currentIndex,
                onTap: () => navigationShell.goBranch(0),
              ),
              _buildNavItem(
                icon: Icons.search_rounded,
                label: 'البحث',
                index: 1,
                currentIndex: navigationShell.currentIndex,
                onTap: () => navigationShell.goBranch(1),
              ),
              const SizedBox(width: 48), // Space for FAB
              _buildNavItem(
                icon: Icons.receipt_long_rounded,
                label: 'رحلاتي',
                index: 2,
                currentIndex: navigationShell.currentIndex,
                onTap: () => navigationShell.goBranch(2),
              ),
              _buildNavItem(
                icon: Icons.person_rounded,
                label: 'حسابي',
                index: 3,
                currentIndex: navigationShell.currentIndex,
                onTap: () => navigationShell.goBranch(3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required int currentIndex,
    required VoidCallback onTap,
  }) {
    final isSelected = index == currentIndex;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected ? AppColors.primary : AppColors.textLight,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textLight,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
