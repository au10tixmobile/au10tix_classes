// ignore_for_file: must_be_immutable, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/au10tix_class.dart';
import '../../models/next_event.dart';
import '../../screens/class_details_screen.dart';
import '../../helpers/next_class_helper.dart';
import '../../providers/auth_user.dart';
import '../../widgets/details/next_class_status.dart';

class ClassItem extends StatefulWidget {
  final Au10tixClass au10tixClass;

  const ClassItem(this.au10tixClass);

  @override
  State<ClassItem> createState() => _ClassItemState();
}

class _ClassItemState extends State<ClassItem> {
  NextEvent? _nextEvent;
  AuthUser? _user;

  @override
  Widget build(BuildContext context) {
    _user = Provider.of<AuthUser>(context, listen: false);
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        ClassDetailsScreen.routeName,
        arguments: widget.au10tixClass,
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
                  tag: widget.au10tixClass.id,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(widget.au10tixClass.imageUrl),
                  ),
                ),
              ],
            ),
            title: Text(widget.au10tixClass.name),
            subtitle: StreamBuilder(
              stream: NextClassHelper.getNextEvent(widget.au10tixClass),
              builder: (context, AsyncSnapshot<NextEvent> snapshot) {
                if (snapshot.connectionState != ConnectionState.waiting &&
                    snapshot.data != null) {
                  _nextEvent = snapshot.data;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      Text(
                        'Next class: ${_nextEvent!.nextDay} ${_nextEvent!.nextDate}',
                      ),
                      const SizedBox(height: 5),
                      NextClassStatus(true, _isNotEnrolled(), _isNotWaiting()),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => NextClassHelper.enrollToEvent(
                                context,
                                widget.au10tixClass,
                                _nextEvent!,
                                _user!,
                                _handleWaitingList),
                            child: Text(
                              _isNotEnrolled()
                                  ? _isNotWaiting()
                                      ? 'Enroll'
                                      : 'Drop'
                                  : 'Leave',
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return const Text('Next class: TBD');
                }
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

  bool _isNotEnrolled() => NextClassHelper.isNotEnrolled(_nextEvent!, _user!);

  bool _isNotWaiting() => NextClassHelper.isNotWaiting(_nextEvent!, _user!);

  void _handleWaitingList(bool join) async {
    NextClassHelper.handleWaitingList(
      join,
      widget.au10tixClass,
      _nextEvent!,
      _user!,
    );
  }
}
