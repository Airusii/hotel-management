import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hotel_app/features/auth/auth_provider.dart';
import 'package:hotel_app/core/widgets/notification_bottom_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  const UserProfileScreen({super.key});

  @override
  ConsumerState<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Заполните все поля')),
      );
      return;
    }

    ref.read(authProvider.notifier).signIn(email, password);
  }

  void _signOut() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Выход'),
        content: const Text('Вы уверены, что хотите выйти из аккаунта?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Выйти'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      ref.read(authProvider.notifier).signOut();
    }
  }

  void _showNotificationsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const NotificationBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    ref.listen(authProvider, (previous, next) {
      if (next.status == AuthStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage ?? 'Ошибка авторизации'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    });

    final isAuthenticated = authState.status == AuthStatus.authenticated;
    final isLoading = authState.status == AuthStatus.loading;

    if (isAuthenticated) {
      return _buildProfileSettings(context, authState);
    }

    return _buildLoginForm(context, isLoading);
  }

  // ── ФОРМА ВХОДА ────────────────────────────────────────────────
  Widget _buildLoginForm(BuildContext context, bool isLoading) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: theme.colorScheme.primaryContainer,
                    child: Icon(
                      Icons.person_outline,
                      size: 44,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Войти в аккаунт',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 36),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    enabled: !isLoading,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Пароль',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    obscureText: _obscurePassword,
                    enabled: !isLoading,
                  ),
                  const SizedBox(height: 28),
                  FilledButton(
                    onPressed: isLoading ? null : _login,
                    child: isLoading
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text('Войти'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── НАСТРОЙКИ ПРОФИЛЯ (КАБИНЕТ) ────────────────────────────────
  Widget _buildProfileSettings(BuildContext context, AuthState authState) {
    final theme = Theme.of(context);
    final roleAsyncValue = ref.watch(userRoleProvider);
    final user = FirebaseAuth.instance.currentUser;

    final roleName = roleAsyncValue.when(
      data: (roleStr) => _roleLabelFromString(roleStr),
      loading: () => 'Загрузка...',
      error: (_, __) => 'Ошибка роли',
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Кабинет')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: theme.colorScheme.surfaceVariant,
                  backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
                  child: user?.photoURL == null ? Icon(Icons.person, size: 50, color: theme.colorScheme.primary) : null,
                ),
                const SizedBox(height: 16),
                Text(
                  user?.displayName ?? 'Пользователь',
                  style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Chip(
                  label: Text(roleName),
                  backgroundColor: theme.colorScheme.secondaryContainer,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          const _SectionHeader(label: 'Мои действия'),
          _ProfileTile(
            icon: Icons.calendar_month_outlined,
            title: 'Бронирования',
            onTap: () => context.go('/profile/my_bookings'),
          ),
          _ProfileTile(
            icon: Icons.star_outline,
            title: 'Мои отзывы',
            onTap: () => context.go('/profile/my_reviews'),
          ),
          _ProfileTile(
            icon: Icons.help_outline,
            title: 'Помощь и FAQ',
            onTap: () => context.go('/profile/faq'),
          ),
          const SizedBox(height: 16),
          const _SectionHeader(label: 'Настройки'),
          _ProfileTile(
            icon: Icons.settings_outlined,
            title: 'Настройки профиля',
            onTap: () => context.go('/profile/settings'),
          ),
          _ProfileTile(
            icon: Icons.notifications_outlined,
            title: 'Уведомления',
            badge: true,
            onTap: () => _showNotificationsSheet(context),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: OutlinedButton.icon(
              onPressed: _signOut,
              icon: Icon(Icons.logout, color: theme.colorScheme.error),
              label: Text('Выйти из аккаунта', style: TextStyle(color: theme.colorScheme.error)),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(56),
                side: BorderSide(color: theme.colorScheme.error.withOpacity(0.5)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _roleLabelFromString(String? role) {
    switch (role) {
      case 'admin': return 'Администратор';
      case 'employee': return 'Сотрудник';
      default: return 'Клиент';
    }
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8, top: 16),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool badge;

  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.badge = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: ListTile(
        leading: badge 
          ? Badge(child: Icon(icon, color: theme.colorScheme.primary))
          : Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right, size: 20),
        onTap: onTap,
      ),
    );
  }
}
