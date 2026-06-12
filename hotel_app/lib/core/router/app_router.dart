import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hotel_app/features/admin/screens/admin_dashboard_screen.dart';
import 'package:hotel_app/features/admin/screens/admin_employees_screen.dart';
import 'package:hotel_app/features/admin/screens/admin_rooms_screen.dart';
import 'package:hotel_app/features/admin/screens/admin_services_screen.dart';
import 'package:hotel_app/features/auth/auth_provider.dart';
import 'package:hotel_app/features/auth/login_screen.dart';
import 'package:hotel_app/core/widgets/main_scaffold.dart';

import '../../features/home/home_screen.dart';
import '../../features/home/screens/room_details_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/profile/profile_settings_screen.dart';
import 'package:hotel_app/features/tasks/screens/admin_tasks_screen.dart';
import 'package:hotel_app/features/profile/my_bookings_screen.dart';
import 'package:hotel_app/features/profile/my_reviews_screen.dart';
import 'package:hotel_app/features/admin/screens/admin_calendar_screen.dart';
import 'package:hotel_app/features/admin/screens/admin_main_stats_screen.dart';

import '../../features/tasks/screens/employee_tasks_screen.dart';
import 'package:hotel_app/features/news/create_news_screen.dart';
import 'package:hotel_app/features/client/screens/guest_services_screen.dart';
import 'package:hotel_app/features/client/screens/active_stay_screen.dart';
import 'package:hotel_app/features/admin/screens/admin_news_active_screen.dart';
import 'package:hotel_app/features/admin/screens/admin_news_archive_screen.dart';
import 'package:hotel_app/features/admin/screens/admin_faq_screen.dart';
import 'package:hotel_app/features/client/screens/guest_faq_screen.dart';
import 'package:hotel_app/features/bookings/screens/bookings_history_screen.dart';
import 'package:hotel_app/features/bookings/screens/admin_requests_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final userRoleAsync = ref.watch(userRoleProvider);
  final authStateAsync = ref.watch(authStateChangesProvider);

  return GoRouter(
    initialLocation: '/home',
    navigatorKey: _rootNavigatorKey,
    redirect: (context, state) {
      final isAuthenticated = authStateAsync.value != null;
      final role = userRoleAsync.value;
      final path = state.uri.path;

      final isAdminPath = path.startsWith('/admin');
      final isTasksPath = path.startsWith('/tasks');
      final isProfilePath = path.startsWith('/profile');
      final isServicesPath = path.startsWith('/services');

      if (!isAuthenticated) {
        if (isAdminPath || isTasksPath || isProfilePath || isServicesPath) {
          return '/login';
        }
        return null;
      }

      if (path == '/login') {
        return '/profile';
      }

      if (userRoleAsync.isLoading) {
        return null;
      }

      if (role == 'employee') {
        if (path == '/home' || isAdminPath) {
          return '/tasks';
        }
      }

      if (isAdminPath && role != 'admin') {
        return '/home';
      }

      if (isTasksPath && (role != 'admin' && role != 'employee')) {
        return '/home';
      }

      return null;
    },
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScaffold(navigationShell: navigationShell);
        },
        branches: [
          // Ветка 0: Главная
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          // Ветка 1: Услуги
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/services',
                builder: (context, state) => const GuestServicesScreen(),
              ),
            ],
          ),
          // Ветка 2: Кабинет (Профиль + FAQ)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const UserProfileScreen(),
                routes: [
                  GoRoute(path: 'my_bookings', builder: (context, state) => const MyBookingsScreen()),
                  GoRoute(path: 'active_stay', builder: (context, state) => const ActiveStayScreen()),
                  GoRoute(path: 'my_reviews', builder: (context, state) => const MyReviewsScreen()),
                  GoRoute(path: 'settings', builder: (context, state) => const ProfileSettingsScreen()),
                  GoRoute(path: 'faq', builder: (context, state) => const GuestFaqScreen()),
                ],
              ),
              GoRoute(
                path: '/login',
                builder: (context, state) => const LoginScreen(),
              ),
            ],
          ),
          // Ветка 3: Задачи
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/tasks',
                builder: (context, state) {
                  if (userRoleAsync.value == 'admin') {
                    return const AdminTasksScreen();
                  } else {
                    return const EmployeeTasksScreen();
                  }
                },
              ),
            ],
          ),
          // Ветка 4: Админка
          StatefulShellBranch(
            routes: [
              ShellRoute(
                builder: (context, state, child) => AdminDashboardScreen(child: child),
                routes: [
                  GoRoute(path: '/admin', builder: (context, state) => const AdminMainStatsScreen()),
                  GoRoute(path: '/admin/rooms', builder: (context, state) => const AdminRoomsScreen()),
                  GoRoute(path: '/admin/services', builder: (context, state) => const AdminServicesScreen()),
                  GoRoute(path: '/admin/employees', builder: (context, state) => const AdminEmployeesScreen()),
                  GoRoute(path: '/admin/calendar', builder: (context, state) => const AdminCalendarScreen()),
                  GoRoute(path: '/admin/faq', builder: (context, state) => const AdminFaqScreen()),
                  GoRoute(
                    path: '/admin/requests',
                    builder: (context, state) => const AdminRequestsScreen(),
                  ),
                  GoRoute(
                    path: '/admin/bookings_history',
                    builder: (context, state) => const BookingsHistoryScreen(),
                  ),
                  GoRoute(
                    path: '/admin/news/create',
                    builder: (context, state) => const CreateNewsScreen(),
                  ),
                  GoRoute(
                    path: '/admin/news/active',
                    builder: (context, state) => const AdminNewsActiveScreen(),
                  ),
                  GoRoute(
                    path: '/admin/news/archive',
                    builder: (context, state) => const AdminNewsArchiveScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      // Маршруты вне нижнего меню
      GoRoute(
        path: '/room/:id',
        builder: (context, state) {
          final roomId = state.pathParameters['id']!;
          return RoomDetailsScreen(roomId: roomId);
        },
      ),
    ],
  );
});
