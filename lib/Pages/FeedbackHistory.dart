import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Controllers/FireStoreController.dart'; // Import the FireStoreController
import '../Models/Feedback.dart';

class FeedbackHistoryPage extends StatelessWidget {
  final FireStoreController _fireStoreController = FireStoreController(); // Create an instance of FireStoreController

  @override
  Widget build(BuildContext context) {
    final currentUserID = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback History'),
      ),
      body: FutureBuilder<List<FeedbackData>>(
        future: _fireStoreController.getFeedbackForUser(currentUserID), // Use getFeedbackForUser method from FireStoreController
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error loading feedback"));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(child: Text("No feedback found"));
          }

          final feedbackList = snapshot.data!;

          double overallRating = feedbackList.isEmpty
              ? 0.0
              : feedbackList
              .map((feedback) => feedback.rating)
              .reduce((a, b) => a + b) /
              feedbackList.length;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Overall Rating:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${overallRating.toStringAsFixed(1)}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: feedbackList.length,
                  itemBuilder: (context, index) {
                    final feedback = feedbackList[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Card(
                        elevation: 4,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Text(
                              feedback.rating.toStringAsFixed(1),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(
                            'Rating: ${feedback.rating.toStringAsFixed(1)}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 4),
                              Text(feedback.feedback),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
