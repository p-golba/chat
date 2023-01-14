import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chats/PvIorgj5dLFKEtdA0TC8/messages')
            .snapshots(),
        builder: (context, snapshot) {
          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.all(8),
                child: const Text('This works!'),
              );
            },
          );
        },
      ),
    );
  }
}
