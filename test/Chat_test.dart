import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:register/Models/Message.dart';

void main() {
  group('Message Class Tests', () {
    final Timestamp testTime = Timestamp.now();

    test('Message initializes correctly with non-null message and null imageURL', () {
      final message = Message(
        senderID: 'sender1',
        receiverID: 'receiver1',
        senderEmail: 'sender@example.com',
        message: 'Hello, world!',
        imageURL: null,
        time: testTime,
      );

      expect(message.senderID, 'sender1');
      expect(message.receiverID, 'receiver1');
      expect(message.senderEmail, 'sender@example.com');
      expect(message.message, 'Hello, world!');
      expect(message.imageURL, isNull);
      expect(message.time, testTime);
    });

    test('Message initializes correctly with null message and non-null imageURL', () {
      final message = Message(
        senderID: 'sender1',
        receiverID: 'receiver1',
        senderEmail: 'sender@example.com',
        message: null,
        imageURL: 'http://example.com/image.png',
        time: testTime,
      );

      expect(message.message, isNull);
      expect(message.imageURL, 'http://example.com/image.png');
    });

    test('Message.toMap produces correct map output', () {
      final message = Message(
        senderID: 'sender1',
        receiverID: 'receiver1',
        senderEmail: 'sender@example.com',
        message: 'Hello, world!',
        imageURL: null,
        time: testTime,
      );

      final map = message.toMap();

      expect(map['senderID'], 'sender1');
      expect(map['receiverID'], 'receiver1');
      expect(map['senderEmail'], 'sender@example.com');
      expect(map['message'], 'Hello, world!');
      expect(map['imageURL'], isNull);
      expect(map['time'], testTime);
    });

    test('Message initialization asserts if both message and imageURL are null', () {
      expect(
            () => Message(
          senderID: 'sender1',
          receiverID: 'receiver1',
          senderEmail: 'sender@example.com',
          message: null,
          imageURL: null,
          time: testTime,
        ),
        throwsA(isA<AssertionError>()),
      );
    });
  });
}
