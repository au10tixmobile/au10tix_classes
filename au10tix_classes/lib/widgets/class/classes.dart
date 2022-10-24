// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../class/class_item.dart';
import '../../models/au10tix_class.dart';

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
            Au10tixClass.parseResult(
                classesDoc[i].data() as Map<String, dynamic>, classesDoc[i].id),
          ),
          itemCount: classesDoc.length,
        );
      },
    );
  }
}
