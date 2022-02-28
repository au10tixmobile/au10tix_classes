// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import '../../models/au10tix_class.dart';

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
                'Occurs Every ${_au10tixClass.occurance}',
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
          if (_au10tixClass.description.isNotEmpty)
            ClassInfoSection(_au10tixClass.description)
        ],
      ),
    );
  }
}

class ClassInfoSection extends StatefulWidget {
  final String description;
  var _detailsExpanded = false;
  ClassInfoSection(this.description, {Key? key}) : super(key: key);

  @override
  _ClassInfoSectionState createState() => _ClassInfoSectionState();
}

class _ClassInfoSectionState extends State<ClassInfoSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExpansionTile(
          title: const Text(
            "Class Details",
            style: TextStyle(color: Colors.black),
          ),
          subtitle: widget._detailsExpanded
              ? null
              : widget.description.length > 20
                  ? Text('${widget.description.substring(0, 30)}...')
                  : Text(widget.description),
          onExpansionChanged: (value) {
            setState(() {
              widget._detailsExpanded = value;
            });
          },
          children: <Widget>[
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(16.0),
              child: Text(widget.description),
            )
          ],
        ),
      ],
    );
  }
}
