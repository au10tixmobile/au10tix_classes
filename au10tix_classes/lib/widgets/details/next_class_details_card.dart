import 'package:flutter/material.dart';

class NextClassDetailsCard extends StatelessWidget {
  const NextClassDetailsCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        children: const [
          ListTile(
            title: Text("Next class information"),
          ),
          Divider(),
          ListTile(
            title: Text("Date"),
            subtitle: Text("butterfly.little@gmail.com"),
            leading: Icon(Icons.calendar_view_day),
          ),
          ListTile(
            title: Text("Participating"),
            subtitle: Text("https://www.littlebutterfly.com"),
            leading: Icon(Icons.person),
          ),
          ListTile(
            title: Text("Updates"),
            subtitle: Text("+977-9815225566"),
            leading: Icon(Icons.message),
          ),
          ListTile(
            title: Text("Enrollment status"),
            subtitle: Text('Enrolled'),
            leading: Icon(Icons.add_circle_outline),
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: null,
                  child: Text("Enroll"),
                ),
              ))
        ],
      ),
    );
  }
}
