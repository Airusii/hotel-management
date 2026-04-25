import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'service_model.dart';

final servicesRepositoryProvider = Provider((ref) => ServicesRepository());

class ServicesRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<HotelService>> getServices() {
    return _firestore
        .collection('services')
        .where('isArchived', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => HotelService.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> addService(HotelService service) async {
    await _firestore.collection('services').add(service.toMap());
  }

  Future<void> updateService(HotelService service) async {
    await _firestore.collection('services').doc(service.id).update(service.toMap());
  }

  Future<void> archiveService(String serviceId) async {
    await _firestore.collection('services').doc(serviceId).update({'isArchived': true});
  }
}
