import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:register/Models/ProductInfo.dart';
import 'dart:io';
import '../Auth/Auth.dart';
import '../Controllers/ChatController.dart';
import 'package:image_picker/image_picker.dart';

class Chat extends StatefulWidget {
  final String receiverId;
  final ProductInfo product;
  const Chat({super.key, required this.receiverId, required this.product});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> with WidgetsBindingObserver{
  final TextEditingController textController = TextEditingController();
  final ChatController chatController = ChatController();
  final Auth auth = Auth();
  FocusNode focusNode = FocusNode();
  File? image;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 100), () =>scrollDown(duration: const Duration(milliseconds: 400)));
      }
    });
    
    Future.delayed(const Duration(milliseconds: 200), () =>scrollDown(duration: const Duration(milliseconds: 400)));
  }

  @override
  void dispose(){
    WidgetsBinding.instance.removeObserver(this);
    focusNode.dispose();
    textController.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    scrollDown(duration: Duration.zero);
  }

  final ScrollController scrollController = ScrollController();
  void scrollDown({required Duration duration}) {
    if (duration == Duration.zero) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    } else {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: duration,
        curve: Curves.easeOut,
      );
    }
  }

  void sendMessage() async {
    await chatController.sendMessage(widget.product.productID, widget.receiverId, textController.text, image);
    textController.clear();
    image = null;

    scrollDown(duration: const Duration(milliseconds: 400));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.network(
              widget.product.imageURL,
              width: 80,
              height: 100,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.product.productName, style: Theme.of(context).appBarTheme.titleTextStyle,),
                Opacity(opacity: 0.7, child: Text(widget.product.category, style: const TextStyle(fontSize: 16.0),),),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),

          Expanded(
            child: buildAllMessages(),
          ),

          writeMessage(context),
        ]
      ),
    );
  }

  Widget buildAllMessages() {
    String senderId = auth.currentUser!.uid;
    return StreamBuilder(
        stream: ChatController().getMessages(widget.product.productID, widget.receiverId, senderId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          }
          else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          else {
            return ListView(
              controller: scrollController,
              children:
                snapshot.data!.docs.map((doc) => buildSingleMessage(context, doc)).toList()
            );
          }
        }
    );
  }

  Widget buildSingleMessage(BuildContext context, DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    List<Widget> messageWidgets = [];

    if (data["imageURL"] != null) {
      messageWidgets.add(Image.network(data["imageURL"]));
    }

    if (data["message"] != null && data["message"].isNotEmpty) {
      messageWidgets.add(Text(data["message"]));
    }
    bool isReceiver = data["receiverID"] == widget.receiverId;
    return Align(

      alignment: isReceiver ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 1,
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        child: ChatBubble(
          isReceiver: isReceiver,
          content: Column(
            crossAxisAlignment: isReceiver ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: messageWidgets,
          ),
        ),
      ),
    );
  }

  Widget writeMessage(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(30.0),

      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.image),
            onPressed: () async {
              final picked = await ImagePicker().pickImage(source: ImageSource.gallery);

              if (picked != null) {
                image = File(picked.path);
              } else {
                print('No image selected.');
              }
            },
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                controller: textController,
                decoration: InputDecoration(
                  hintText: "Type a message",
                  hintStyle: TextStyle(color: Theme.of(context).hintColor),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: sendMessage,
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final Widget content;
  final bool isReceiver;

  const ChatBubble({super.key, required this.content, required this.isReceiver});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: isReceiver ? Colors.indigo : Theme.of(context).primaryColor,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(15.0),
          topRight: const Radius.circular(15.0),
          bottomLeft: isReceiver ? const Radius.circular(15.0) : const Radius.circular(0),
          bottomRight: isReceiver ? const Radius.circular(0) : const Radius.circular(15.0),
        ),
      ),
      child: DefaultTextStyle(
        style: const TextStyle(color: Colors.white, fontSize: 16.0),
        child: content,
      ),
    );
  }
}