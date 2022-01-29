import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/au10tix_class.dart';
import '../widgets/details/class_details_content.dart';
import '../providers/auth_user.dart';
import '../widgets/details/new_class_event.dart';

class ClassDetailsScreen extends StatelessWidget {
  static const routeName = '/class_details';

  late Au10tixClass _au10tixClass;

  void _addNewEvent(DateTime chosenDate) async {
    await FirebaseFirestore.instance
        .collection('events')
        .add({'date': chosenDate}).then((value) {
      FirebaseFirestore.instance
          .collection('classes')
          .doc(_au10tixClass.id)
          .update({'nextEvent': value});
    });
  }

  @override
  Widget build(BuildContext context) {
    _au10tixClass = ModalRoute.of(context)!.settings.arguments as Au10tixClass;
    final bool isAdmin = Provider.of<AuthUser>(context, listen: false).isAdmin;

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Container(
                color: Colors.black54,
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  _au10tixClass.name,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              background: Hero(
                tag: _au10tixClass.id,
                child: Image.network(
                  _au10tixClass.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                ClassDetailsContent(_au10tixClass),
                const SizedBox(
                    height:
                        700), //placeholder to fill the page and make it scrollable
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              onPressed: () => _startAddNewEvent(context),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  void _startAddNewEvent(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (bCtx) {
          return NewClassEvent(_addNewEvent);
        });
  }
}
