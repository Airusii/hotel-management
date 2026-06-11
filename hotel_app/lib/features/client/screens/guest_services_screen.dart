import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/features/services/service_model.dart';
import 'package:hotel_app/features/services/services_provider.dart';
import 'package:hotel_app/l10n/app_localizations.dart';
class GuestServicesScreen extends ConsumerWidget {
  const GuestServicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final servicesAsync = ref.watch(servicesStreamProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.servicesTitle),
        centerTitle: true,
      ),
      body: servicesAsync.when(
        data: (allServices) {
          final activeServices = allServices.where((s) => !s.isArchived).toList();
          
          if (activeServices.isEmpty) {
            return Center(child: Text(l10n.servicesEmpty));
          }

          final Map<String, List<HotelService>> groupedServices = {};
          for (var service in activeServices) {
            groupedServices.putIfAbsent(service.type, () => []).add(service);
          }

          final categories = groupedServices.keys.toList();

          return DefaultTabController(
            length: categories.length,
            child: Column(
              children: [
                TabBar(
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  tabs: categories.map((cat) => Tab(text: cat)).toList(),
                ),
                Expanded(
                  child: TabBarView(
                    children: categories.map((cat) {
                      final services = groupedServices[cat]!;
                      return ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: services.length,
                        itemBuilder: (context, index) {
                          final service = services[index];
                          return _ServiceCard(service: service);
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text(l10n.servicesErrorLoading(err.toString()))),
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final HotelService service;

  const _ServiceCard({required this.service});

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'restaurant':
      case 'food':
        return Icons.restaurant;
      case 'cleaning':
      case 'mop':
        return Icons.cleaning_services;
      case 'spa':
        return Icons.spa;
      case 'local_taxi':
        return Icons.local_taxi;
      default:
        return Icons.room_service;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Icon(_getIcon(service.icon), color: theme.colorScheme.onPrimaryContainer),
        ),
        title: Text(
          service.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '\$${service.basePrice.toStringAsFixed(2)}',
          style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.w500),
        ),
        trailing: FilledButton.tonal(
          onPressed: () => _showOrderConfirmation(context, service),
          child: Text(l10n.servicesOrder),
        ),
      ),
    );
  }

  void _showOrderConfirmation(BuildContext context, HotelService service) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.shopping_cart_outlined, size: 48, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                l10n.servicesConfirmTitle,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.servicesConfirmBody(service.name, service.basePrice.toStringAsFixed(2)),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(l10n.servicesCancel),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.servicesOrdered),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      child: Text(l10n.servicesConfirm),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
