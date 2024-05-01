import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackData {
  final String userId;
  final String productId;
  final double rating;
  final String feedback;
  final DateTime timestamp;

  FeedbackData({
    required this.userId,
    required this.productId,
    required this.rating,
    required this.feedback,
    required this.timestamp,
  });

  factory FeedbackData.fromFirestore(Map<String, dynamic> doc) {
    return FeedbackData(
      userId: doc['userId'] ?? '',
      productId: doc['productId'] ?? '',
      rating: doc['rating']?.toDouble() ?? 0.0,
      feedback: doc['feedback'] ?? '',
      timestamp: (doc['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'productId': productId,
      'rating': rating,
      'feedback': feedback,
      'timestamp': FieldValue.serverTimestamp(),
    };
  }
}
