import 'package:flutter/material.dart';

class DialogHelper {
  static void showEnrollDialog(
    BuildContext context,
    String title,
    String body,
    Function handleWaitingList,
    bool join,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(ctx).pop(false);
              },
              child: const Text('No')),
          TextButton(
              onPressed: () {
                handleWaitingList(join);
                Navigator.of(ctx).pop(true);
              },
              child: const Text('Yes')),
        ],
      ),
    );
  }
}
