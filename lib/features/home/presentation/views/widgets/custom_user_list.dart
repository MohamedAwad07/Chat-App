import 'dart:developer';
import 'package:chat_app/core/service%20locator/service_locator.dart';
import 'package:chat_app/features/Auth/presentation/controller/auth_cubit.dart';
import 'package:chat_app/features/home/presentation/views/widgets/cusom_user_tile.dart';
import 'package:chat_app/features/home/presentation/views/widgets/skeletonizer_users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BuildUserList extends StatelessWidget {
  const BuildUserList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: sl.get<FirebaseFirestore>().collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SkeletonizerUserList();
        } else if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }
        final users = snapshot.data!.docs;
        if (users.length == 1) {
          log("No users found!");
          return const _NoUsersFoundMessage();
        }
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                final userId = user['uid'];
                final username = user['username'] ?? 'Unknown';
                final status = user['status'] ?? 'offline';

                if (userId == AuthCubit.get(context).currentUser?.uid) return const SizedBox.shrink();

                return UserTile(
                  username: username,
                  status: status,
                  userId: userId,
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _NoUsersFoundMessage extends StatelessWidget {
  const _NoUsersFoundMessage();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'No users found!',
        style: TextStyle(
          color: Colors.grey,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class StatusAvatar extends StatelessWidget {
  final String status;

  const StatusAvatar({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: Colors.grey[300],
          child: const Icon(Icons.person, color: Colors.black),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: CircleAvatar(
            radius: 7,
            backgroundColor: status == 'online' ? Colors.green : Colors.red,
          ),
        ),
      ],
    );
  }
}
