import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hotel_app/features/admin/screens/admin_main_stats_screen.dart';
import 'package:hotel_app/features/admin/widgets/add_booking_dialog.dart';

class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({
    super.key,
    this.child,
  });

  final Widget? child;

  @override
  ConsumerState<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> {
  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).matchedLocation;
    if (location == '/admin') return 0;
    
    // Группа Брони (1-3)
    if (location.startsWith('/admin/calendar')) return 1;
    if (location.startsWith('/admin/requests')) return 2;
    if (location.startsWith('/admin/bookings_history')) return 3;
    
    // Группа Новости (7-9)
    if (location.startsWith('/admin/news/create')) return 7;
    if (location.startsWith('/admin/news/active')) return 8;
    if (location.startsWith('/admin/news/archive')) return 9;

    if (location.startsWith('/admin/rooms')) return 4;
    if (location.startsWith('/admin/services')) return 5;
    if (location.startsWith('/admin/employees')) return 6;
    if (location.startsWith('/admin/faq')) return 10;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width >= 600;
    final selectedIndex = _calculateSelectedIndex(context);
    final theme = Theme.of(context);

    // Подпункты "Брони"
    final bookingSubItems = [
      (title: 'Шахматка', icon: Icons.grid_view_rounded, path: '/admin/calendar', index: 1),
      (title: 'Новые заявки', icon: Icons.notification_important_outlined, path: '/admin/requests', index: 2),
      (title: 'Создать бронь', icon: Icons.add_circle_outline_rounded, path: null, index: -1),
      (title: 'История броней', icon: Icons.history_rounded, path: '/admin/bookings_history', index: 3),
    ];

    // Подпункты "Новости"
    final newsSubItems = [
      (title: 'Сделать публикацию', icon: Icons.add_comment_outlined, path: '/admin/news/create', index: 7),
      (title: 'Активные публикации', icon: Icons.campaign_outlined, path: '/admin/news/active', index: 8),
      (title: 'Архив', icon: Icons.archive_outlined, path: '/admin/news/archive', index: 9),
    ];

    final bool isBookingGroupSelected = selectedIndex >= 1 && selectedIndex <= 3;
    final bool isNewsGroupSelected = selectedIndex >= 7 && selectedIndex <= 9;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hotel Admin'),
      ),
      drawer: !isLargeScreen
          ? Drawer(
              child: ListView(
                children: [
                  _buildDrawerHeader(theme),
                  _buildDrawerItem(
                    icon: Icons.dashboard_outlined,
                    title: 'Обзор',
                    isSelected: selectedIndex == 0,
                    onTap: () => context.go('/admin'),
                  ),
                  _buildExpansionTile(
                    theme: theme,
                    title: 'Брони',
                    icon: Icons.book_online_outlined,
                    selectedIndex: selectedIndex,
                    subItems: bookingSubItems,
                    isExpanded: isBookingGroupSelected,
                  ),
                  _buildDrawerItem(
                    icon: Icons.room_outlined,
                    title: 'Номера',
                    isSelected: selectedIndex == 4,
                    onTap: () => context.go('/admin/rooms'),
                  ),
                  _buildDrawerItem(
                    icon: Icons.room_service_outlined,
                    title: 'Услуги',
                    isSelected: selectedIndex == 5,
                    onTap: () => context.go('/admin/services'),
                  ),
                  _buildDrawerItem(
                    icon: Icons.people_outline,
                    title: 'Сотрудники',
                    isSelected: selectedIndex == 6,
                    onTap: () => context.go('/admin/employees'),
                  ),
                  _buildExpansionTile(
                    theme: theme,
                    title: 'Новости',
                    icon: Icons.newspaper_outlined,
                    selectedIndex: selectedIndex,
                    subItems: newsSubItems,
                    isExpanded: isNewsGroupSelected,
                  ),
                  _buildDrawerItem(
                    icon: Icons.help_outline,
                    title: 'FAQ',
                    isSelected: selectedIndex == 10,
                    onTap: () => context.go('/admin/faq'),
                  ),
                ],
              ),
            )
          : null,
      body: Row(
        children: [
          if (isLargeScreen)
            SizedBox(
              width: 260,
              child: Material(
                elevation: 0,
                color: theme.colorScheme.surface,
                child: ListView(
                  children: [
                    const SizedBox(height: 16),
                    _buildSidebarItem(
                      context,
                      icon: Icons.dashboard_outlined,
                      title: 'Обзор',
                      isSelected: selectedIndex == 0,
                      onTap: () => context.go('/admin'),
                    ),
                    _buildExpansionTile(
                      theme: theme,
                      title: 'Брони',
                      icon: Icons.book_online_outlined,
                      selectedIndex: selectedIndex,
                      subItems: bookingSubItems,
                      isExpanded: isBookingGroupSelected,
                      isSidebar: true,
                    ),
                    _buildSidebarItem(
                      context,
                      icon: Icons.room_outlined,
                      title: 'Номера',
                      isSelected: selectedIndex == 4,
                      onTap: () => context.go('/admin/rooms'),
                    ),
                    _buildSidebarItem(
                      context,
                      icon: Icons.room_service_outlined,
                      title: 'Услуги',
                      isSelected: selectedIndex == 5,
                      onTap: () => context.go('/admin/services'),
                    ),
                    _buildSidebarItem(
                      context,
                      icon: Icons.people_outline,
                      title: 'Сотрудники',
                      isSelected: selectedIndex == 6,
                      onTap: () => context.go('/admin/employees'),
                    ),
                    _buildExpansionTile(
                      theme: theme,
                      title: 'Новости',
                      icon: Icons.newspaper_outlined,
                      selectedIndex: selectedIndex,
                      subItems: newsSubItems,
                      isExpanded: isNewsGroupSelected,
                      isSidebar: true,
                    ),
                    _buildSidebarItem(
                      context,
                      icon: Icons.help_outline,
                      title: 'FAQ',
                      isSelected: selectedIndex == 10,
                      onTap: () => context.go('/admin/faq'),
                    ),
                  ],
                ),
              ),
            ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: widget.child ?? const AdminMainStatsScreen(),
          ),
        ],
      ),
    );
  }

  Widget _buildExpansionTile({
    required ThemeData theme,
    required String title,
    required IconData icon,
    required int selectedIndex,
    required List<dynamic> subItems,
    required bool isExpanded,
    bool isSidebar = false,
  }) {
    return Theme(
      data: theme.copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        leading: Icon(icon, color: isExpanded ? theme.colorScheme.primary : null),
        title: Text(
          title,
          style: TextStyle(
            color: isExpanded ? theme.colorScheme.primary : null,
            fontWeight: isExpanded ? FontWeight.bold : null,
          ),
        ),
        initiallyExpanded: isExpanded,
        children: subItems.map((item) {
          final isSelected = item.index == selectedIndex;
          return ListTile(
            contentPadding: const EdgeInsets.only(left: 56, right: 16),
            leading: Icon(item.icon, size: 20, color: isSelected ? theme.colorScheme.primary : null),
            title: Text(
              item.title,
              style: TextStyle(
                fontSize: 14,
                color: isSelected ? theme.colorScheme.primary : null,
                fontWeight: isSelected ? FontWeight.bold : null,
              ),
            ),
            selected: isSelected,
            onTap: () {
              if (item.path == null) {
                _showAddBookingDialog(context);
              } else {
                context.go(item.path);
              }
              if (!isSidebar) Navigator.pop(context);
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDrawerHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.only(top: 50, left: 16, bottom: 16),
      color: theme.colorScheme.primaryContainer.withOpacity(0.3),
      child: Text(
        'Меню админа',
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      selected: isSelected,
      onTap: () {
        onTap();
        Navigator.pop(context);
      },
    );
  }

  Widget _buildSidebarItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(icon, color: isSelected ? theme.colorScheme.primary : null),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? theme.colorScheme.primary : null,
          fontWeight: isSelected ? FontWeight.bold : null,
        ),
      ),
      selected: isSelected,
      onTap: onTap,
    );
  }

  void _showAddBookingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AddBookingDialog(),
    );
  }
}
