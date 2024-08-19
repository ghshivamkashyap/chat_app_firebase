import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() {
    return _NewMessageState();
  }
}

class _NewMessageState extends State<NewMessage> {
  final _messageController = TextEditingController();

  void _sendMessage() async {
    final val = _messageController.text;

    if (val.isEmpty) {
      return;
    }

    final user = FirebaseAuth.instance.currentUser!;

    // print('User id***************************: ${user.uid}');
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    // print('User data***************************: ${userData.data()}');

    await FirebaseFirestore.instance.collection('chats').add({
      'message': val,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'userName': userData.data()!['name'],
      'userImage': userData.data()!['image_url'],
    });

    _messageController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 16, right: 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: "Start typing..."),
              controller: _messageController,
              enableSuggestions: true,
              textCapitalization: TextCapitalization.sentences,
              cursorColor: Theme.of(context).colorScheme.primary,
              // decoration: const InputDecoration(labelText: "Start typing..."),
            ),
          ),
          IconButton(
            color: Theme.of(context).colorScheme.primary,
            onPressed: _sendMessage,
            icon: const Icon(Icons.send),
          )
        ],
      ),
    );
  }
}
