import 'package:chat_app/core/utils/app_assets.dart';
import 'package:chat_app/features/home/presentation/views/widgets/build_message_list.dart';
import 'package:chat_app/core/service%20locator/service_locator.dart';
import 'package:chat_app/core/utils/app_colors.dart';
import 'package:chat_app/features/home/data/repos/repos.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  final String currentUserName;
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final String receiverId;
  final TextEditingController _messageController = TextEditingController();

  ChatScreen({
    super.key,
    required this.currentUserName,
    required this.auth,
    required this.firestore,
    required this.receiverId,
  });

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await sl<ChatService>().sendMessage(receiverId, _messageController.text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 65, 119, 105),
      appBar: AppBar(
        elevation: 10,
        backgroundColor: Color.fromARGB(255, 65, 119, 105),
        title: Row(
          spacing: 16,
          children: [
            CircleAvatar(
              radius: 15,
              backgroundColor: Colors.grey[300],
              child: const Icon(
                Icons.person,
                color: Colors.black,
              ),
            ),
            Text(
              currentUserName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Assets.assetsImagesChatWallpaper),
                  fit: BoxFit.cover,
                ),
              ),
              child: BuildMessagesList(
                auth: auth,
                messageStream: sl<ChatService>().getMessages(auth.currentUser!.uid, receiverId),
              ),
            ),
          ),
          _buildMessageInputField(),
        ],
      ),
    );
  }

  Widget _buildMessageInputField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          spacing: 5,
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  focusColor: AppColors.primaryLight,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.primaryLight,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  labelText: 'Message',
                  hintText: 'Enter your message',
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryLight,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_upward,
                  color: Colors.white,
                ),
                onPressed: sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
