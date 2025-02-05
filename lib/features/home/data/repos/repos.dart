import 'dart:developer';

import 'package:chat_app/features/home/data/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class ChatService {
  Stream<List<Map<String, dynamic>>> getUsers();
  Future<void> sendMessage(String receiverId, String message);
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId);
}

class ChatServiceImpl implements ChatService {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  ChatServiceImpl({required this.auth, required this.firestore});
  @override
  Future<void> sendMessage(String receiverId, String message) async {
    // get current user info
    final String currentUserId = auth.currentUser!.uid;
    final String currentEmail = auth.currentUser!.email ?? 'Unknown';
    final Timestamp timestamp = Timestamp.now();

    //create a new message document

    Message newMessage = Message(
      senderId: currentUserId,
      senderEmail: currentEmail,
      receiverId: receiverId,
      message: message,
      timestamp: timestamp,
    );

    // construct chat room id for the two users sorted to avoid duplicates

    List<String> ids = [
      currentUserId,
      receiverId
    ];
    ids.sort();
    String chatRoomId = ids.join('-');

    // add new message to the chat room

    await firestore.collection('chat_rooms').doc(chatRoomId).collection('messages').add(
          newMessage.toMap(),
        );
  }

  @override
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    List<String> ids = [
      userId,
      otherUserId
    ];
    ids.sort();
    String chatRoomId = ids.join('-');
    return firestore.collection('chat_rooms').doc(chatRoomId).collection('messages').orderBy('timestamp' , descending: false).snapshots();
  }

  @override
Stream<List<Map<String, dynamic>>> getUsers() async* {
  try {
    final snapshot = await firestore.collection('users').get();
    final users = snapshot.docs.map((doc) => doc.data()).toList();
    yield users;
  } catch (e) {
    log('Error fetching users: $e');
    yield [];
  }
}

}
