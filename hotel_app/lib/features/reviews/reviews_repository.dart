import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/features/reviews/review_model.dart';

class ReviewsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addReview(Review review) async {
    await _firestore.collection('reviews').add(review.toMap());
  }

  Stream<List<Review>> getRoomReviews(String roomId) {
    return _firestore
        .collection('reviews')
        .where('roomId', isEqualTo: roomId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Review.fromMap(doc.data(), doc.id))
            .toList());
  }

  Stream<List<Review>> getAllReviews() {
    return _firestore
        .collection('reviews')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Review.fromMap(doc.data(), doc.id))
            .toList());
  }
}

final reviewsRepositoryProvider = Provider((ref) => ReviewsRepository());

final roomReviewsStreamProvider = StreamProvider.family<List<Review>, String>((ref, roomId) {
  return ref.watch(reviewsRepositoryProvider).getRoomReviews(roomId);
});

final allReviewsStreamProvider = StreamProvider<List<Review>>((ref) {
  return ref.watch(reviewsRepositoryProvider).getAllReviews();
});
