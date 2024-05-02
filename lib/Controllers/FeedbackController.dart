import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:register/Models/Feedback.dart';

class FeedbackService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addFeedback(FeedbackData feedback) async {
    await _firestore.collection('Feedbacks').add(feedback.toFirestore());
  }
}
