import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/features/faq/faq_model.dart';

class FaqRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<FaqModel>> getPublicFaq() {
    return _firestore
        .collection('faq')
        .where('isPublic', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => FaqModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Stream<List<FaqModel>> getAdminFaq() {
    return _firestore
        .collection('faq')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => FaqModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> askQuestion({required String question, String? userId, String? userName}) async {
    final faq = FaqModel(
      id: '',
      question: question,
      userId: userId,
      userName: userName,
      createdAt: DateTime.now(),
      isPublic: false,
    );
    await _firestore.collection('faq').add(faq.toMap());
  }

  Future<void> answerQuestion(String faqId, String answer, bool isPublic) async {
    await _firestore.collection('faq').doc(faqId).update({
      'answer': answer,
      'isPublic': isPublic,
      'answeredAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteFaq(String faqId) async {
    await _firestore.collection('faq').doc(faqId).delete();
  }
}

final faqRepositoryProvider = Provider((ref) => FaqRepository());

final publicFaqProvider = StreamProvider<List<FaqModel>>((ref) {
  return ref.watch(faqRepositoryProvider).getPublicFaq();
});

final adminFaqProvider = StreamProvider<List<FaqModel>>((ref) {
  return ref.watch(faqRepositoryProvider).getAdminFaq();
});
