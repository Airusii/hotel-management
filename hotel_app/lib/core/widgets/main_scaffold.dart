import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hotel_app/features/auth/auth_provider.dart';

class MainScaffold extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const MainScaffold({
    super.key,
    required this.navigationShell,
  });

  void _onTap(int index, List<int> visibleIndices) {
    navigationShell.goBranch(
      visibleIndices[index],
      initialLocation: visibleIndices[index] == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangesProvider);
    final isAuthenticated = authState.value != null;
    final userRoleAsync = ref.watch(userRoleProvider);
    final isWide = MediaQuery.of(context).size.width >= 600;

    // Список всех возможных вкладок (Обновлен: FAQ перенесен внутрь Кабинета)
    final List<({IconData icon, String label, int branchIndex})> allItems = [
      (icon: Icons.home, label: 'Главная', branchIndex: 0),
      (icon: Icons.room_service_outlined, label: 'Услуги', branchIndex: 1),
      (icon: Icons.person, label: isAuthenticated ? 'Кабинет' : 'Войти', branchIndex: 2),
      (icon: Icons.task, label: 'Задачи', branchIndex: 3),
      (icon: Icons.settings, label: 'Админка', branchIndex: 4),
    ];

    // Логика фильтрации вкладок
    List<({IconData icon, String label, int branchIndex})> getVisibleItems(String? role) {
      return allItems.where((item) {
        if (!isAuthenticated) {
          // Для неавторизованных: Главная, Услуги и Войти
          return item.branchIndex <= 2;
        }
        // Для авторизованных:
        if (item.branchIndex == 3) return role == 'admin' || role == 'employee';
        if (item.branchIndex == 4) return role == 'admin';
        return true;
      }).toList();
    }

    if (!isAuthenticated) {
      final visibleItems = getVisibleItems(null);
      final visibleIndices = visibleItems.map((e) => e.branchIndex).toList();
      return _buildScaffold(context, visibleItems, visibleIndices, isWide);
    }

    return userRoleAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, _) => Scaffold(body: Center(child: Text('Ошибка: $err'))),
      data: (role) {
        final visibleItems = getVisibleItems(role);
        final visibleIndices = visibleItems.map((e) => e.branchIndex).toList();
        return _buildScaffold(context, visibleItems, visibleIndices, isWide);
      },
    );
  }

  Widget _buildScaffold(BuildContext context, List<dynamic> visibleItems, List<int> visibleIndices, bool isWide) {
    final currentIndex = visibleIndices.indexOf(navigationShell.currentIndex);

    return Scaffold(
      body: Row(
        children: [
          if (isWide)
            NavigationRail(
              selectedIndex: currentIndex != -1 ? currentIndex : 0,
              onDestinationSelected: (index) => _onTap(index, visibleIndices),
              labelType: NavigationRailLabelType.all,
              destinations: visibleItems
                  .map((item) => NavigationRailDestination(
                        icon: Icon(item.icon),
                        label: Text(item.label),
                      ))
                  .toList(),
            ),
          Expanded(child: navigationShell),
        ],
      ),
      bottomNavigationBar: !isWide
          ? BottomNavigationBar(
              currentIndex: currentIndex != -1 ? currentIndex : 0,
              onTap: (index) => _onTap(index, visibleIndices),
              type: BottomNavigationBarType.fixed,
              items: visibleItems
                  .map((item) => BottomNavigationBarItem(
                        icon: Icon(item.icon),
                        label: item.label,
                      ))
                  .toList(),
            )
          : null,
    );
  }
}
