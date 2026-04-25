import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'service_model.dart';
import 'services_repository.dart';

final servicesStreamProvider = StreamProvider<List<HotelService>>((ref) {
  return ref.watch(servicesRepositoryProvider).getServices();
});
