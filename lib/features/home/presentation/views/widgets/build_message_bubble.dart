import 'package:chat_app/core/utils/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BuildMessageBubble extends StatelessWidget {
  const BuildMessageBubble({super.key, required this.message, required this.isSender});

  final QueryDocumentSnapshot<Object?>message;
  final bool isSender;

  String _formatTime(DateTime dateTime) {
  int hour = dateTime.hour % 12; 
  hour = hour == 0 ? 12 : hour;

  String period = dateTime.hour >= 12 ? 'PM' : 'AM';

  // Return formatted time
  return '$hour:${dateTime.minute.toString().padLeft(2, '0')} $period';
}
  @override
  Widget build(BuildContext context) {
    final timestamp = message['timestamp'] as Timestamp?;
    final timeString = timestamp != null
    ? _formatTime(timestamp.toDate())
    : '';
    return Column(
      crossAxisAlignment: isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.5),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSender ? AppColors.primaryLight : Colors.grey[300],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
              bottomLeft: isSender ? Radius.circular(16) : Radius.zero,
              bottomRight: isSender ? Radius.zero : Radius.circular(16),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 2),
                blurRadius: 3,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message['message'],
                style: TextStyle(
                  fontSize: 16,
                  color: isSender ? Colors.white : Colors.black,
                ),
                softWrap: true,
                overflow: TextOverflow.visible,
              ),
              SizedBox(height: 4),
              Text(
                timeString,
                style: TextStyle(
                  fontSize: 12,
                  color: isSender ? Colors.white70 : Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
