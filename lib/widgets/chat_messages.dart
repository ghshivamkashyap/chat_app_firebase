import 'package:chat_app_firebase/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No messages found..'),
          );
        }

        return ListView.builder(
            reverse: true,
            padding: const EdgeInsets.only(bottom: 35, left: 15, right: 15),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (ctx, idx) {
              final chatMessage = snapshot.data!.docs[idx].data();
              final nextMessage = idx + 1 < snapshot.data!.docs.length
                  ? snapshot.data!.docs[idx + 1].data()
                  : null;

              final currUserId = chatMessage['userId'];
              final nextUseeId =
                  nextMessage != null ? nextMessage['userId'] : null;

              final nextUserIsSame = currUserId == nextUseeId;

              if (nextUserIsSame) {
                return MessageBubble.next(
                    message: chatMessage['message'],
                    isMe: user.uid == currUserId);
              } else {
                return MessageBubble.first(
                    userImage: chatMessage['userImage'],
                    username: chatMessage['userName'],
                    message: chatMessage['message'],
                    isMe: user.uid == currUserId);
              }
            }

            // Text(
            //   snapshot.data!.docs[idx].data()['message'],
            // ),
            );
      },
    );
    // return Center(
    //   child: Text('No messages found..'),
    // );
  }
}
