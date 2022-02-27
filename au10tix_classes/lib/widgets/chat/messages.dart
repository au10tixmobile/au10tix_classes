// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Messages extends StatelessWidget {
  final String id;
  const Messages(this.id);

  Future<List<ChatMsgs>> _getData(List<DocumentReference> chats) async {
    List<ChatMsgs> msgs = [];
    await Future.forEach(chats, (DocumentReference chat) async {
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(chat.id)
          .get()
          .then(
              (value) => msgs.add(ChatMsgs(value['text'], value['createdAt'])));
    });
    return msgs;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream:
          FirebaseFirestore.instance.collection('events').doc(id).snapshots(),
      builder: (ctx, AsyncSnapshot<DocumentSnapshot> chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final event = chatSnapshot.data!;
        List<DocumentReference> msgs = [];
        if (event.data()!.containsKey('chatMsgs')) {
          msgs = List.from(event.data()!['chatMsgs']);
        }
        return FutureBuilder(
          future: _getData(msgs),
          builder: (context, AsyncSnapshot<List<ChatMsgs>> snapshot) {
            if (snapshot.connectionState != ConnectionState.waiting &&
                snapshot.data!.isNotEmpty) {
              return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  reverse: true,
                  itemBuilder: (ctx, index) => Padding(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                DateFormat('dd/MM/yy HH:mm')
                                    .format(snapshot.data![index].createdAt!),
                                style: const TextStyle(color: Colors.grey)),
                            Text(
                              snapshot.data![index].msg!,
                              style: const TextStyle(fontSize: 20),
                            )
                          ],
                        ),
                      ),
                  itemCount: msgs.length);
            }
            return const Text('');
          },
        );
      },
    );
  }
}

class ChatMsgs {
  String? msg;
  DateTime? createdAt;
  ChatMsgs(this.msg, dynamic createdAt) {
    this.createdAt = DateTime.parse(createdAt.toDate().toString());
  }
}
