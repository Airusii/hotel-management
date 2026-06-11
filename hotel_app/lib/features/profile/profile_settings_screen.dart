import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hotel_app/l10n/app_localizations.dart';
import 'package:hotel_app/core/widgets/locale_selector.dart';

class ProfileSettingsScreen extends ConsumerStatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  ConsumerState<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends ConsumerState<ProfileSettingsScreen> {
  final _nameController = TextEditingController();
  String? _selectedAvatarUrl;
  bool _isLoading = false;

  // Кулдаун: 24 часа для смены имени/аватара
  final Duration _updateCooldown = const Duration(hours: 24);

  // Список аватаров для выбора (DiceBear)
  final List<String> _avatars = [
    'https://api.dicebear.com/7.x/avataaars/png?seed=Felix',
    'https://api.dicebear.com/7.x/avataaars/png?seed=Aneka',
    'https://api.dicebear.com/7.x/avataaars/png?seed=George',
    'https://api.dicebear.com/7.x/avataaars/png?seed=Katie',
    'https://api.dicebear.com/7.x/avataaars/png?seed=Molly',
    'https://api.dicebear.com/7.x/avataaars/png?seed=Jasper',
  ];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _nameController.text = user.displayName ?? '';
      _selectedAvatarUrl = user.photoURL;
    }
  }

  Future<void> _updateProfile() async {
    final l10n = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final newName = _nameController.text.trim();
    if (newName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.loginFillFields)),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final lastUpdate = (userDoc.data()?['lastProfileUpdate'] as Timestamp?)?.toDate();

      if (lastUpdate != null && DateTime.now().difference(lastUpdate) < _updateCooldown) {
        final remaining = _updateCooldown - DateTime.now().difference(lastUpdate);
        throw l10n.errorGeneric('Wait ${remaining.inHours}h');
      }

      await user.updateDisplayName(newName);
      if (_selectedAvatarUrl != null) {
        await user.updatePhotoURL(_selectedAvatarUrl);
      }

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': newName,
        'photoUrl': _selectedAvatarUrl,
        'lastProfileUpdate': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.profileSettingsTitle)), // Simplified success message
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorGeneric(e.toString())), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleChangePassword() async {
    final l10n = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.email == null) return;

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: user.email!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.profileSettingsChangePassword)),
        );
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.errorGeneric(e.toString()))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileSettingsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            l10n.profileSettingsChooseAvatar,
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 80,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _avatars.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final url = _avatars[index];
                final isSelected = _selectedAvatarUrl == url;
                return GestureDetector(
                  onTap: () => setState(() => _selectedAvatarUrl = url),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? theme.colorScheme.primary : Colors.transparent,
                        width: 3,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 35,
                      backgroundColor: theme.colorScheme.surfaceVariant,
                      backgroundImage: NetworkImage(url),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 32),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: l10n.roomDetailsGuestName,
              border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
              prefixIcon: const Icon(Icons.person_outline),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _isLoading ? null : _updateProfile,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(56),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : Text(l10n.profileSettingsSave),
          ),
          const SizedBox(height: 32),
          const LocaleSelectorCard(),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),
          Text(l10n.profileSettingsSecurity, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: _isLoading ? null : _handleChangePassword,
            icon: const Icon(Icons.lock_reset),
            label: Text(l10n.profileSettingsChangePassword),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(56),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
