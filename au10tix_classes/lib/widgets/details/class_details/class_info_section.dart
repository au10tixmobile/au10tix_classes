// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

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
