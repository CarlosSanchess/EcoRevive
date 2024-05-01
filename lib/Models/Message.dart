import 'package:cloud_firestore/cloud_firestore.dart';

class Message{
  final String senderID;
  final String receiverID;
  final String senderEmail;
  final String? message;
  final String? imageURL;
  final Timestamp time;

  Message({
    required this.senderID,
    required this.receiverID,
    required this.senderEmail,
    this.message,
    this.imageURL,
    required this.time
  }) : assert(message != null || imageURL != null);

  Map<String, dynamic> toMap(){
    return {
      'senderID': senderID,
      'receiverID': receiverID,
      'senderEmail': senderEmail,
      'message': message,
      'imageURL': imageURL,
      'time': time
    };
  }
}