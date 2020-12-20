import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_familly_app/models/calendarModel.dart';
import 'package:flutter_familly_app/screens/pages/addEvent.dart';
import 'package:flutter_familly_app/services/firebaseMethods.dart';
import 'package:flutter_familly_app/src/pages/call.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:flutter_familly_app/services/firebaseHelper.dart';
import 'package:permission_handler/permission_handler.dart';

String groupCallId;
FirebaseHelper _firebaseHelpers = FirebaseHelper();

class EventDetails extends StatelessWidget {
  final CalendarEvent event;

  const EventDetails({Key key, this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime dateTimeNow = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(dateTimeNow);
    print(formatted);

    DateFormat("EEEE,dd MMMM, yyyy").format(dateTimeNow);
    final DateFormat eventDateFormatter = DateFormat('yyyy-MM-dd');
    final String eventFormatted = eventDateFormatter.format(event.date);
    print(eventFormatted);

    _firebaseHelpers.getFamCallCode(event.id).then((value) {
      if (value == null) groupCallId = "";
      groupCallId = value;
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddEventPage(
                              event: event,
                            )));
              }),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              //delete the calendar event after confirmation
              //when showdialog return null :> need to catch that
              final confirm = await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: Text('Warning!'),
                            content: Text("Are you sure you want to delete?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: Text("Delete"),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ),
                            ],
                          )) ??
                  false;
              if (confirm) {
                //validated so delete
                await eventDBS.removeItem(event.id);
                Navigator.pop(context);
              }
            },
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          // Text(event.isPublic ? "Public" : "Private"),
          ListTile(
            leading: Icon(Icons.event),
            title: Text(event.title),
            subtitle: Text(DateFormat("EEEE,dd MMMM, yyyy").format(event.date)),
          ),

          const SizedBox(height: 10.0),
          if (event.description != null)
            ListTile(
              title: Text(event.description),
              leading: Icon(Icons.short_text),
              subtitle: Text("event.groupMeetingCode"),
            ),

          if (groupCallId != null)
            ListTile(
                leading: Icon(Icons.video_call),
                title: Text("Click to join meeting"),
                onTap: () async {
                  if (eventFormatted != formatted) {
                    Fluttertoast.showToast(
                        msg:
                            "The meeting is locked untill : ${eventFormatted}");
                  } else if (eventFormatted == formatted) {
                    await _handleCameraAndMic(Permission.camera);
                    await _handleCameraAndMic(Permission.microphone);
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CallPage(
                                channelName: groupCallId,
                                role: ClientRole.Broadcaster)));
                  }
                }),

          const SizedBox(height: 20.0),
        ],
      ),
    );
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
  }

  displayToastMessage(String msg, BuildContext context) {
    Fluttertoast.showToast(msg: msg);
  }
}
