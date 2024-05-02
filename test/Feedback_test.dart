import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:register/Models/Feedback.dart';

void main() {
  group('FeedbackData', () {
    test('fromFirestore should correctly deserialize data', () {
      final map = {
        'reviewerId': 'user1',
        'revieweeId': 'user2',
        'rating': 4.5,
        'feedback': 'Great service!',
        'timestamp': Timestamp.fromDate(DateTime(2021, 1, 1)),
      };

      final feedback = FeedbackData.fromFirestore(map);

      expect(feedback.reviewerId, 'user1');
      expect(feedback.revieweeId, 'user2');
      expect(feedback.rating, 4.5);
      expect(feedback.feedback, 'Great service!');
      expect(feedback.timestamp, DateTime(2021, 1, 1));
    });

    test('toFirestore should correctly serialize data', () {
      final feedback = FeedbackData(
        reviewerId: 'user1',
        revieweeId: 'user2',
        rating: 4.5,
        feedback: 'Great service!',
        timestamp: DateTime(2021, 1, 1),
      );

      final map = feedback.toFirestore();

      expect(map['reviewerId'], 'user1');
      expect(map['revieweeId'], 'user2');
      expect(map['rating'], 4.5);
      expect(map['feedback'], 'Great service!');
    });
  });
}
