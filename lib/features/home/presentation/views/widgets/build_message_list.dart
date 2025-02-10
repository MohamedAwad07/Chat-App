import 'package:chat_app/features/home/presentation/views/widgets/build_message_bubble.dart';
import 'package:chat_app/features/home/presentation/views/widgets/shimmer_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BuildMessagesList extends StatelessWidget {
  const BuildMessagesList({super.key, this.messageStream, required this.auth, required this.controller});
  final Stream<QuerySnapshot<Object?>>? messageStream;
  final FirebaseAuth auth;
  final ScrollController controller;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: messageStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) => ShimmerMessages(index: index),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        } else if (snapshot.hasData) {
          final messages = snapshot.data!.docs;
          if (messages.isEmpty) {
            return const Center(
              child: Text(
                'No messages yet!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }
          return ListView.builder(
            reverse: true,
            controller: controller,
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];
              final isSender = message['senderId'] == auth.currentUser!.uid;

              return Align(
                alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
                child: BuildMessageBubble(message: message, isSender: isSender),
              );
            },
          );
        } else {
          return const Center(child: Text('No messages yet'));
        }
      },
    );
  }
}
