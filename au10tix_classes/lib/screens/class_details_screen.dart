// ignore_for_file: use_key_in_widget_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/au10tix_class.dart';
import '../widgets/details/class_details/class_details_card.dart';
import '../widgets/details/next_class_details_card.dart';
import '../providers/auth_user.dart';
import '../widgets/details/admin_options.dart';
import '../models/next_event.dart';

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

  @override
  Widget build(BuildContext context) {
    final bool isAdmin = Provider.of<AuthUser>(context, listen: false).isAdmin;

    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              SizedBox(
                height: 200,
                width: double.infinity,
                child: Hero(
                  tag: _au10tixClass.id,
                  child: Image.network(
                    _au10tixClass.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(16.0, 150.0, 16.0, 16.0),
                child: Column(
                  children: <Widget>[
                    ClassDetilasCard(au10tixClass: _au10tixClass),
                    const SizedBox(height: 20.0),
                    NextClassDetailsCard(au10tixClass: _au10tixClass)
                  ],
                ),
              ),
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
              )
            ],
          ),
        ),
        floatingActionButton: isAdmin
            ? FloatingActionButton(
                onPressed: () => _startAddNewEvent(context),
                child: const Icon(Icons.add),
              )
            : null);
  }

  void _addNewChatMsg(Map<String, Object> chat) async {
    chat.putIfAbsent(
        "eventId", () => _au10tixClass.nextEventRef!.path.substring(7));
    final chatRef =
        await FirebaseFirestore.instance.collection('chats').add(chat);
    final event = await FirebaseFirestore.instance
        .collection("events")
        .doc(_au10tixClass.nextEventRef!.path.substring(7))
        .get()
        .then((value) => _updateNextEvent(value));
    event.chatMsgs.add(chatRef);
    FirebaseFirestore.instance
        .collection("events")
        .doc(_au10tixClass.nextEventRef!.path.substring(7))
        .update({'chatMsgs': event.chatMsgs});
  }

  void _addNewEvent(bool isCancel) async {
    final NextEvent event;
    if (_au10tixClass.nextEventRef != null) {
      event = await FirebaseFirestore.instance
          .collection("events")
          .doc(_au10tixClass.nextEventRef!.path.substring(7))
          .get()
          .then((value) => _updateNextEvent(value));
      FirebaseFirestore.instance
          .collection("events")
          .doc(_au10tixClass.nextEventRef!.path.substring(7))
          .update({'status': isCancel ? 'Cancelled' : 'Done'});
    } else {
      event = NextEvent(
        date: _au10tixClass.date,
        participants: [],
        waitingParticipants: [],
        chatMsgs: [],
      );
    }

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
    final data = a.data() as Map<String, dynamic>;
    final DateTime date = DateTime.parse(data['date'].toDate().toString());
    List<DocumentReference> chatMsgs = [];
    if (data.containsKey('chatMsgs')) {
      chatMsgs = List.from(data['chatMsgs']);
    }
    return NextEvent(
      date: date,
      participants: [],
      waitingParticipants: [],
      chatMsgs: chatMsgs,
    );
  }

  void _startAddNewEvent(BuildContext ctx) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: ctx,
      builder: (bCtx) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Wrap(children: [AdminOptions(_addNewEvent, _addNewChatMsg)]),
        );
      },
    );
  }
}
