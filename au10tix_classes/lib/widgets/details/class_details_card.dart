import 'package:flutter/material.dart';
import '/models/au10tix_class.dart';

class ClassDetilasCard extends StatelessWidget {
  const ClassDetilasCard({
    Key? key,
    required Au10tixClass au10tixClass,
  })  : _au10tixClass = au10tixClass,
        super(key: key);

  final Au10tixClass _au10tixClass;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(top: 16.0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(5.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                _au10tixClass.name,
                style: Theme.of(context).textTheme.headline6,
              ),
              Text(
                'Occurs Every ${_au10tixClass.getOccurance()}',
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: [
                    Text(_au10tixClass.instructorName),
                    const Text('Instructor',
                        style: TextStyle(color: Colors.grey))
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(_au10tixClass.attendenceMax.toString()),
                    const Text('Participatns',
                        style: TextStyle(color: Colors.grey))
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          ExpansionTile(
            title: const Text(
              "Class Details",
              style: TextStyle(color: Colors.black),
            ),
            children: <Widget>[
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.all(16.0),
                child: Text(_au10tixClass.description),
              )
            ],
          ),
        ],
      ),
    );
  }
}
