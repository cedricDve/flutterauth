import 'package:flutter/material.dart';
import 'package:flutter_familly_app/models/calendarModel.dart';
import 'package:flutter_familly_app/screens/pages/addEvent.dart';
import 'package:flutter_familly_app/services/firebaseMethods.dart';
import 'package:intl/intl.dart';

class EventDetails extends StatelessWidget {
  final CalendarEvent event;

  const EventDetails({Key key, this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
