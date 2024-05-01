import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackData {
  final String reviewerId;
  final String revieweeId;
  final double rating;
  final String feedback;
  final DateTime timestamp;

  FeedbackData({
    required this.reviewerId,
    required this.revieweeId,
    required this.rating,
    required this.feedback,
    required this.timestamp,
  });

  factory FeedbackData.fromFirestore(Map<String, dynamic> doc) {
    return FeedbackData(
      reviewerId: doc['reviewerId'] ?? '',
      revieweeId: doc['revieweeId'] ?? '',
      rating: doc['rating']?.toDouble() ?? 0.0,
      feedback: doc['feedback'] ?? '',
      timestamp: (doc['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'reviewerId': reviewerId,
      'revieweeId': revieweeId,
      'rating': rating,
      'feedback': feedback,
      'timestamp': FieldValue.serverTimestamp(),
    };
  }
}

