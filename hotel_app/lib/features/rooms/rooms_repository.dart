import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'room_model.dart';

final roomsRepositoryProvider = Provider((ref) => RoomsRepository());

class RoomsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Room>> getRooms() {
    return _firestore
        .collection('rooms')
        .where('isArchived', isEqualTo: false)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => Room.fromMap(doc.data())).toList());
  }

  Stream<List<String>> getRoomTypes() {
    return _firestore.collection('room_types').snapshots().map(
        (snapshot) => snapshot.docs.map((doc) => doc.id).toList());
  }

  Future<void> addRoom(Room room) async {
    final docRef = _firestore.collection('rooms').doc();
    final newRoom = room.copyWith(id: docRef.id);
    await docRef.set(newRoom.toMap());
  }

  Future<void> updateRoom(Room room) async {
    await _firestore.collection('rooms').doc(room.id).update(room.toMap());
  }

  Future<void> archiveRoom(String roomId) async {
    await _firestore.collection('rooms').doc(roomId).update({'isArchived': true});
  }
}

final roomsStreamProvider = StreamProvider<List<Room>>((ref) {
  return ref.watch(roomsRepositoryProvider).getRooms();
});

final roomTypesStreamProvider = StreamProvider<List<String>>((ref) {
  return ref.watch(roomsRepositoryProvider).getRoomTypes();
});
