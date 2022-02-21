import 'package:au10tix_classes/providers/auth_user.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '/models/au10tix_class.dart';
import '/models/next_event.dart';
import '/screens/class_details_screen.dart';

class ClassItem extends StatelessWidget {
  final Au10tixClass au10tixClass;

  const ClassItem(this.au10tixClass);

  bool isEnrolled(NextEvent nextEvent, AuthUser user) =>
      nextEvent.participants.contains(user.userRef!);

  Future<NextEvent> _getData() async {
    return await FirebaseFirestore.instance
        .collection('events')
        .doc(au10tixClass.nextEventRef!.path.substring(7))
        .get()
        .then((value) => _updateNextEvent(value));
  }

  NextEvent _updateNextEvent(DocumentSnapshot a) {
    final DateTime date = DateTime.parse(a.data()!['date'].toDate().toString());
    final List<DocumentReference> participants =
        List.from(a.data()!['participants']);
    return NextEvent(
        date: date, participants: participants, waitingParticipants: []);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthUser>(context, listen: false);
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        ClassDetailsScreen.routeName,
        arguments: au10tixClass,
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 5,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: au10tixClass.id,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(au10tixClass.imageUrl),
                  ),
                ),
              ],
            ),
            title: Text(au10tixClass.name),
            subtitle: FutureBuilder(
              future: _getData(),
              builder: (context, AsyncSnapshot<NextEvent> snapshot) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    snapshot.data != null
                        ? Text(
                            'Next class: ${DateFormat('EEEE').format(DateTime.now())} ${DateFormat('dd/MM/yy').format(snapshot.data!.date!)}',
                          )
                        : const Text('Next class: TBD'),
                    const SizedBox(height: 5),
                    snapshot.data != null && isEnrolled(snapshot.data!, user)
                        ? Text(
                            'You are enrolled in this class',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                          )
                        : Text(
                            'You are not enrolled in this class',
                            style: TextStyle(
                              color: Theme.of(context).errorColor,
                            ),
                          ),
                  ],
                );
              },
            ),
            trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.arrow_forward_ios),
                ]),
          ),
        ),
      ),
    );
  }
}
