import 'package:flutter/material.dart';
import 'package:flutter_familly_app/models/calendarModel.dart';
import 'package:flutter_familly_app/services/auth.dart';
import 'package:flutter_familly_app/services/firebaseMethods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'dart:math' show Random;
import 'package:random_string/random_string.dart';

import 'package:lite_rolling_switch/lite_rolling_switch.dart';

class AddEventPage extends StatefulWidget {
  final DateTime selectedDate;
  final CalendarEvent event;

  const AddEventPage({Key key, this.selectedDate, this.event})
      : super(key: key);

  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool state;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.clear, color: Colors.blue[200]),
          onPressed: () {
            // navigate back
            Navigator.pop(context);
          },
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: ElevatedButton(
                onPressed: () async {
                  // validate data
                  bool validated = _formKey.currentState.validate();

                  if (validated) {
                    //save event
                    _formKey.currentState.save();
                    final data =
                        Map<String, dynamic>.from(_formKey.currentState.value);
                    if (state == false) {
                      data['groupMeetingCode'] = randomAlpha(5);
                      // random sequence of 5 alpha characters i.e. aRzt

                    } else {
                      data['groupMeetingCode'] = null;
                    }
                    data['date'] =
                        (data['date'] as DateTime).millisecondsSinceEpoch;
                    print(data);
                    if (widget.event == null) {
                      data['user_id'] = Auth(auth: _auth).currentUser.uid;
                      //Save data to FireStore with firebase_helpers
                      await eventDBS.create(data);
                    } else {
                      // when user edit => update
                      await eventDBS.updateData(widget.event.id, data);
                    }

                    Navigator.pop(context);
                  }
                },
                child: Text("Save"),
              ),
            ),
          )
        ],
        title: Text('Add Calendar Event'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          // I found a nice pluggin from flutter => form_builder
          // Normaly validation can with Validator : validator: (val) { if (val == null || val.isEmpty) { return "Title should not be empty"; }
          // but form_builder is different => FormBValidator  . compose
          FormBuilder(
              key: _formKey,
              child: Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Column(
                    children: [
                      FormBuilderTextField(
                        // validate data => validator
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
                        ]),
                        name: "title",
                        //pass the initial values : when user wanna edit his profile
                        initialValue: widget.event?.title,
                        decoration: InputDecoration(
                          hintText: "Add Title",
                        ),
                      ),
                      Divider(),
                      FormBuilderTextField(
                        name: "description",
                        //pass the initial values : when user wanna edit his profile
                        initialValue: widget.event?.description,
                        maxLines: 5,
                        minLines: 1,
                        decoration: InputDecoration(
                            hintText: "Add Details",
                            prefixIcon: Icon(Icons.short_text)),
                      ),
                      Divider(),
                      // Divider(),
                      FormBuilderDateTimePicker(
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
                        ]),
                        name: "date",
                        initialValue: widget.event != null
                            ? widget.event.date
                            : widget.selectedDate ?? DateTime.now(),
                        fieldHintText: "Add Date",
                        inputType: InputType.date,
                        format: DateFormat('EEEE, dd MMMM, yyyy'),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.calendar_today_sharp),
                        ),
                      ),
                      Divider(),
                      LiteRollingSwitch(
                        value: true,
                        textOn: 'Event',
                        textOff: 'Meeting',
                        colorOn: Colors.deepOrange,
                        colorOff: Colors.blueGrey,
                        iconOn: Icons.event,
                        iconOff: Icons.group,
                        onChanged: (value) async {
                          if (value == false) {
                            setState(() {
                              state = false;
                              print("dit is de meeting");
                            });
                          } else if (value == true) {
                            setState(() {
                              state = true;
                              print("dit is de evenb");
                            });
                          }
                        },
                      ),
                    ],
                  )))
        ],
      ),
    );
  }
}

/*
                      FormBuilderSwitch(
                        name: "isPublic",
                        title: Text("Public"),
                        //pass the initial values : when user wanna edit his profile
                        initialValue: widget.event?.isPublic ?? false,
                        controlAffinity: ListTileControlAffinity.leading,
                        decoration: InputDecoration(
                            hintText: "Add Details", border: InputBorder.none),
                      ),*/
