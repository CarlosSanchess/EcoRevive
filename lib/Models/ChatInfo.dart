import 'package:register/Models/ProductInfo.dart';

class ChatInfo{
  final String chatId;
  final String senderId;
  final String receiverId;
  final String nameID1;
  final String nameID2;
  final ProductInfo productInfo;

  ChatInfo({
    required this.chatId,
    required this.senderId,
    required this.receiverId,
    required this.nameID1,
    required this.nameID2,
    required this.productInfo,
  });
}