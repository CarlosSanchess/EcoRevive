import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:register/API/API.dart';
import 'package:register/Models/Feedback.dart';

import 'FireStoreController.dart';

class FeedbackService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addFeedback(FeedbackData feedback) async {
    String? userName = await FireStoreController().getUsernameByUid(feedback.reviewerId);
    String FCMtoken = await FireStoreController().getFCMTokenFromCollection(feedback.revieweeId);

  if(userName != null){
    API().sendRating(FCMtoken, userName, feedback.rating.toString());
  }
   await _firestore.collection('Feedbacks').add(feedback.toFirestore());
  }
}
