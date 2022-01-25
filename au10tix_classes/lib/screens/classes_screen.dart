import 'package:flutter/material.dart';

import '../models/au10tix_class.dart';
import '../widgets/class_item.dart';

class ClassesScreen extends StatelessWidget {
  final List<Au10tixClass> _classes = [
    Au10tixClass(
      id: 0,
      name: "Yoga",
      attendenceMax: 10,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Au10tixClass(
      id: 1,
      name: "Pilates",
      attendenceMax: 8,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Au10tix Classes3'),
      ),
      body: ListView.builder(
        itemBuilder: (ctx, i) => ClassItem(_classes[i]),
        itemCount: _classes.length,
      ),
    );
  }
}
