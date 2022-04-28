import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SubscriptionSwitch extends StatefulWidget {
  const SubscriptionSwitch({
    Key? key,
    required this.userRef,
    required this.classId,
  }) : super(key: key);

  final DocumentReference? userRef;
  final String classId;

  @override
  State<SubscriptionSwitch> createState() => _SubscriptionSwitchState();
}

class _SubscriptionSwitchState extends State<SubscriptionSwitch> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SharedPreferences.getInstance(),
      builder: (context, AsyncSnapshot<SharedPreferences> snapshot) {
        return CupertinoSwitch(
            value: isSubscribed(snapshot.data, widget.userRef),
            onChanged: (subscribe) {
              _onSubscribed(subscribe, widget.userRef!);
            });
      },
    );
  }

  bool isSubscribed(SharedPreferences? prefs, DocumentReference? userRef) {
    return prefs?.getStringList('subscriptions')?.contains(userRef?.path) ??
        false;
  }

  void _onSubscribed(bool subscribe, DocumentReference userRef) async {
    final prefs = await SharedPreferences.getInstance();
    var subscriptions = prefs.getStringList('subscriptions') ?? [];
    final fbm = FirebaseMessaging.instance;

    if (subscribe) {
      subscriptions.add(userRef.path);
      fbm.subscribeToTopic(widget.classId);
    } else if (!subscribe && subscriptions.isNotEmpty) {
      subscriptions.remove(userRef.path);
      fbm.unsubscribeFromTopic(widget.classId);
    }

    setState(() {
      prefs.setStringList('subscriptions', subscriptions);
    });
  }
}
