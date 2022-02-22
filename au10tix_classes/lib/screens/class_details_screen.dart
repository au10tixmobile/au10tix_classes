import 'package:au10tix_classes/widgets/details/admin_options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/au10tix_class.dart';
import '../widgets/details/class_details_content.dart';
import '../providers/auth_user.dart';
import '../models/next_event.dart';
import '../widgets/chat/messages.dart';

class ClassDetailsScreen extends StatefulWidget {
  static const routeName = '/class_details';

  @override
  State<ClassDetailsScreen> createState() => _ClassDetailsScreenState();
}

class _ClassDetailsScreenState extends State<ClassDetailsScreen> {
  late Au10tixClass _au10tixClass;

  @override
  void didChangeDependencies() {
    _au10tixClass = ModalRoute.of(context)!.settings.arguments as Au10tixClass;
    super.didChangeDependencies();
  }

  void _addNewChatMsg(DocumentReference ref) async {
    final event = await FirebaseFirestore.instance
        .collection("events")
        .doc(_au10tixClass.nextEventRef!.path.substring(7))
        .get()
        .then((value) => _updateNextEvent(value));
    event.chatMsgs.add(ref);
    FirebaseFirestore.instance
        .collection("events")
        .doc(_au10tixClass.nextEventRef!.path.substring(7))
        .update({'chatMsgs': event.chatMsgs});
  }

  void _addNewEvent(bool isCancel) async {
    final event = await FirebaseFirestore.instance
        .collection("events")
        .doc(_au10tixClass.nextEventRef!.path.substring(7))
        .get()
        .then((value) => _updateNextEvent(value));

    FirebaseFirestore.instance
        .collection("events")
        .doc(_au10tixClass.nextEventRef!.path.substring(7))
        .update({'status': isCancel ? 'Cancelled' : 'Done'});

    await FirebaseFirestore.instance.collection("events").add({
      'date': event.date!.add(const Duration(days: 7)),
      'status': 'Active',
    }).then((value) {
      FirebaseFirestore.instance
          .collection("classes")
          .doc(_au10tixClass.id)
          .update({'nextEvent': value}).then((value) {
        FirebaseFirestore.instance
            .collection("classes")
            .doc(_au10tixClass.id)
            .get()
            .then((value) {
          setState(() {
            _au10tixClass.nextEventRef = value['nextEvent'];
          });
        });
      });
    });
  }

  NextEvent _updateNextEvent(DocumentSnapshot a) {
    final DateTime date = DateTime.parse(a.data()!['date'].toDate().toString());
    List<DocumentReference> chatMsgs = [];
    if (a.data()!.containsKey('chatMsgs')) {
      chatMsgs = List.from(a.data()!['chatMsgs']);
    }
    return NextEvent(
      date: date,
      participants: [],
      waitingParticipants: [],
      chatMsgs: chatMsgs,
    );
  }

  @override
  Widget build(BuildContext context) {
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
                Text('--------- Updates -------'),
                Expanded(
                  child: Messages(_au10tixClass.nextEventRef!.id),
                ),
                //placeholder to fill the page and make it scrollable
                const SizedBox(height: 700),
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
        return Wrap(children: [AdminOptions(_addNewEvent, _addNewChatMsg)]);
      },
    );
  }
}
