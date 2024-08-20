import 'package:chat_app_firebase/widgets/chat_messages.dart';
import 'package:chat_app_firebase/widgets/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void setupNotifications() async {
    final firebaseMessage = FirebaseMessaging.instance;
    await firebaseMessage.requestPermission();

    final token = await firebaseMessage.getToken();
    firebaseMessage.subscribeToTopic('chat');
    // print('Token is------------------------------------------------------------: $token');
  }

  void initState() {
    super.initState();
    setupNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.exit_to_app_rounded))
        ],
        title: const Text("Chat app"),
      ),
      body: const Column(
        children: [Expanded(child: ChatMessages()), NewMessage()],
      ),
    );
  }
}
