import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './message_bubble.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .orderBy('createdAt')
          .snapshots(),
      builder: (ctx, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final chatDoc = chatSnapshot.data!.docs;
        return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          reverse: true,
          itemBuilder: (ctx, index) => MessageBubble(
            chatDoc[index]['text'],
            DateTime.parse(chatDoc[index]['createdAt'].toDate().toString()),
            key: ValueKey(chatDoc[index].id),
          ),
          itemCount: chatDoc.length,
        );
      },
    );
  }
}
