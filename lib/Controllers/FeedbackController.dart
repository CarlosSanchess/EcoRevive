import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:register/Models/Feedback.dart';
class FeedbackService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addFeedback(FeedbackData feedback) async {
    await _firestore.collection('Feedbacks').add(feedback.toFirestore());
  }

  Stream<List<FeedbackData>> getFeedbackForProduct(String productId) {
    return _firestore
        .collection('Feedbacks')
        .where('productId', isEqualTo: productId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => FeedbackData.fromFirestore(doc.data())).toList());
  }
}

