import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthUser with ChangeNotifier {
  String _name = "";
  bool _isAdmin = false;

  void fetchUser(String userId) async {
    var a =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    _isAdmin = a.data()!['isAdmin'];
    _name = a.data()!['username'];
  }

  bool get isAdmin {
    return _isAdmin;
  }

  String get username {
    return _name;
  }
}
