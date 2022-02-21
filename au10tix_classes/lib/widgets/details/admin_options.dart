import 'package:flutter/material.dart';

class AdminOptions extends StatelessWidget {
  final Function addNewEvent;
  const AdminOptions(this.addNewEvent, {Key? key}) : super(key: key);

  void _openNextClass(BuildContext context, bool isCancel) {
    addNewEvent(isCancel);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 35),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () => _openNextClass(context, true),
              child: const Text("Cancel next class"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _openNextClass(context, false),
              child: const Text("Open next class"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              child: const Text("Send update"),
            ),
          ],
        ),
      ),
    );
  }
}
