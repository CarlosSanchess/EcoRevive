import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:register/Models/Feedback.dart';
import '../Controllers/FeedbackController.dart';

class ReviewPage extends StatefulWidget {
  final String productId;
  final String revieweeId; // User ID of the product owner

  ReviewPage({required this.productId, required this.revieweeId});

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  double _rating = 0;
  final _feedbackController = TextEditingController();
  final FeedbackService _feedbackService = FeedbackService();

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  Future<void> submitReview() async {
    final String reviewerId = FirebaseAuth.instance.currentUser!.uid;
    final String revieweeId = widget.revieweeId;

    FeedbackData feedback = FeedbackData(
      reviewerId: reviewerId,
      revieweeId: revieweeId,
      rating: _rating,
      feedback: _feedbackController.text,
      timestamp: DateTime.now(),
    );

    await _feedbackService.addFeedback(feedback);

    setState(() {
      _rating = 0;
      _feedbackController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Review submitted successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rate User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 20),
            Text('How do you rate this user?', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            RatingBar.builder(
              initialRating: _rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
            SizedBox(height: 40),
            TextField(
              controller: _feedbackController,
              decoration: InputDecoration(
                hintText: 'Leave a feedback...',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: submitReview,
              child: Text('Submit Review'),
            ),
          ],
        ),
      ),
    );
  }
}