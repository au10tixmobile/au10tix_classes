import 'package:au10tix_classes/models/au10tix_class.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../class/class_item.dart';

class Classes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('classes')
          .orderBy('name')
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.data == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final classesDoc = snapshot.data!.docs;
        return ListView.builder(
          itemBuilder: (ctx, i) => ClassItem(
            Au10tixClass(
              id: classesDoc[i].id,
              name: classesDoc[i]['name'],
              attendenceMax: classesDoc[i]['attendenceMax'],
              imageUrl: classesDoc[i]['imageUrl'],
              instructorName: classesDoc[i]['instructorName'],
              description: classesDoc[i]['description'],
            ),
          ),
          itemCount: classesDoc.length,
        );
      },
    );
  }
}
