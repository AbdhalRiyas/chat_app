import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy(
            'createdAt',
            descending: false,
          )
          .snapshots(),
      builder: (context, chatSnapShots) {
        if (chatSnapShots.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!chatSnapShots.hasData || chatSnapShots.data!.docs.isEmpty) {
          return const Center(
            child: Text('No messages yet!'),
          );
        }
        if (chatSnapShots.hasError) {
          return const Center(
            child: Text('An error occurred!'),
          );
        }
        final loadedMessages = chatSnapShots.data!.docs;
        return ListView.builder(
          itemCount: loadedMessages.length,
          itemBuilder: (context, index) =>
              Text(loadedMessages[index].data()['text']),
        );
      },
    );
  }
}
