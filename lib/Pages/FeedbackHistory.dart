import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Auth/Auth.dart';
import '../Controllers/FireStoreController.dart';
import '../Models/Feedback.dart';

class FeedbackHistoryPage extends StatelessWidget {
  final FireStoreController _fireStoreController = FireStoreController();
  final Auth _auth = Auth(); // Initialize Auth class

  Color _ratingColor(double rating) {
    if (rating < 2.0) {
      return Colors.red;
    } else if (rating < 3.0) {
      return Colors.orange;
    } else if (rating < 4.0) {
      return Colors.yellow;
    } else {
      return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser!;
    final currentUserID = currentUser.uid;
    final displayName = currentUser.displayName ?? "User";

    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback History'),
      ),
      body: FutureBuilder<List<FeedbackData>>(
        future: _fireStoreController.getFeedbackForUser(currentUserID),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error loading feedback"));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(child: Text("No feedback found"));
          }

          final feedbackList = snapshot.data!;

          return FutureBuilder<double>(
            future: _fireStoreController.getUserOverallRating(currentUserID),
            builder: (context, ratingSnapshot) {
              if (ratingSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (ratingSnapshot.hasError) {
                return Center(child: Text("Error loading overall rating"));
              }

              final overallRating = ratingSnapshot.data ?? 0.0;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                          decoration: BoxDecoration(
                            color: _ratingColor(overallRating),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            'Logged in as $displayName',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: _ratingColor(overallRating),
                            child: Text(
                              overallRating.toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
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
                        return FutureBuilder<String?>(
                          future: _auth.getDisplayNameById(feedback.reviewerId),
                          builder: (context, nameSnapshot) {
                            if (nameSnapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (nameSnapshot.hasError) {
                              return Text('Error fetching name');
                            }

                            final reviewerName = nameSnapshot.data ?? 'Unknown';

                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              child: Card(
                                elevation: 4,
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: _ratingColor(feedback.rating),
                                    child: Text(
                                      feedback.rating.toStringAsFixed(1),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Reviewer: $reviewerName', // Display reviewer's name
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Card(
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        color: Colors.grey[200],
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            feedback.feedback,
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
