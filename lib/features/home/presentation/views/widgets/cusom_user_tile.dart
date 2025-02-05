import 'package:chat_app/core/service%20locator/service_locator.dart';
import 'package:chat_app/core/utils/app_colors.dart';
import 'package:chat_app/features/home/presentation/views/chat_screen.dart';
import 'package:chat_app/features/home/presentation/views/widgets/custom_user_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserTile extends StatelessWidget {
  final String username;
  final String status;
  final String userId;

  const UserTile({
    super.key,
    required this.username,
    required this.status,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(0),
            leading: StatusAvatar(status: status),
            title: Text(
              username,
              style: GoogleFonts.poppins(fontSize: 16),
            ),
            subtitle: Text(
              status,
              style: TextStyle(
                color: status == 'online' ? Colors.green : Colors.red,
              ),
            ),
            trailing: const Icon(Icons.message, color: AppColors.primaryLight),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(
                    currentUserName: username,
                    receiverId: userId,
                    auth: sl.get<FirebaseAuth>(),
                    firestore: sl.get<FirebaseFirestore>(),
                  ),
                ),
              );
            },
          ),
          const Divider(color: Colors.black45, thickness: 1),
        ],
      ),
    );
  }
}
