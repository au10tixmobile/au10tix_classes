import 'package:flutter/material.dart';
import '../adaptive_flat_button.dart';
import 'package:intl/intl.dart';

class NewClassEvent extends StatefulWidget {
  final Function addTx;

  // ignore: use_key_in_widget_constructors
  const NewClassEvent(this.addTx);

  @override
  State<NewClassEvent> createState() {
    return _NewClassEventState();
  }
}

class _NewClassEventState extends State<NewClassEvent> {
  DateTime? _selectedDate;

  _NewClassEventState();

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2019),
            lastDate: DateTime(2030))
        .then((pickedDate) => {
              if (pickedDate != null)
                {
                  setState(() {
                    _selectedDate = pickedDate;
                  })
                }
            });
  }

  void _submitData() {
    widget.addTx(_selectedDate);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              SizedBox(
                height: 70,
                child: Row(children: [
                  Expanded(
                    child: Text(_selectedDate == null
                        ? "No Date Chosen!"
                        : "Picked Date: ${DateFormat.yMd().format(_selectedDate!)}"),
                  ),
                  AdaptiveFlatButton('Choose Date', _presentDatePicker),
                ]),
              ),
              ElevatedButton(
                child: const Text('Open For Enrollment!'),
                onPressed: _submitData,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
