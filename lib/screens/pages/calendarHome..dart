import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_familly_app/services/auth.dart';
import 'package:flutter_familly_app/services/firebaseHelper.dart';
import 'package:firebase_helpers/firebase_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_familly_app/models/calendarModel.dart';
import 'package:flutter_familly_app/screens/pages/addevent.dart';
import 'package:flutter_familly_app/screens/pages/calendarEvent_details.dart';

import 'package:flutter_familly_app/services/firebaseMethods.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

void main() => runApp(CalendarHome());

class CalendarHome extends StatefulWidget {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  _CalendarHomeState createState() => _CalendarHomeState();
}

class _CalendarHomeState extends State<CalendarHome> {
  FirebaseHelper _firebaseHelper = FirebaseHelper();
  List famMembers = List();
  bool isFam;

  CalendarController _calendarController = CalendarController();
  Map<DateTime, List<CalendarEvent>> _groupedEvents;
// to display events on the calendar
  _groupEvents(List<CalendarEvent> events) {
    _groupedEvents = {};
    events.forEach((event) {
      DateTime date =
          DateTime.utc(event.date.year, event.date.month, event.date.day, 12);
      if (_groupedEvents[date] == null) _groupedEvents[date] = [];
      _groupedEvents[date].add(event);
    });
  }

  void checkIsFamily() async {
    String cuid = Auth(auth: widget.auth).currentUser.uid;
    // Get data from Firestore of current user with cuid ->(CurrentUserID)
    DocumentSnapshot ds =
        await widget.firestore.collection("users").doc(cuid).get();

    setState(() {
      isFam = ds.get('isFamily');
    });
  }

  @override
  void initState() {
    // get the list of the family members of the current user
    super.initState();
    _firebaseHelper.getFamMembers().then((List list) {
      setState(() {
        for (var i = 0; i < list.length; i++) {
          famMembers.add(list[i]);
        }
      });
    });
    checkIsFamily();
  }

  @override
  Widget build(BuildContext context) {
    print(famMembers);

    if (isFam)
      return Scaffold(
        appBar: AppBar(
          title: Text("Calendar"),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              StreamBuilder(
                  //stream: eventDBS.streamList(),
                  stream: eventDBS.streamQueryList(
                      args: [QueryArgsV2("user_id", whereIn: famMembers)]),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      final events = snapshot.data;
                      //init events that will be picked on the calendar
                      _groupEvents(events);
                      // init selected day
                      DateTime selectedDate = _calendarController.selectedDay ??
                          DateTime.utc(DateTime.now().year,
                              DateTime.now().month, DateTime.now().day, 12);
                      ;
                      // if null return empty list
                      final _selectedEvents =
                          _groupedEvents[selectedDate] ?? [];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Card(
                              clipBehavior: Clip.antiAlias,
                              margin: const EdgeInsets.all(8.0),
                              child: TableCalendar(
                                calendarController: _calendarController,
                                events: _groupedEvents,
                                //set state
                                onDaySelected: (date, events, _) {
                                  setState(() {});
                                },

                                headerStyle: HeaderStyle(
                                    decoration: BoxDecoration(),
                                    headerMargin:
                                        const EdgeInsets.only(bottom: 8.0),
                                    titleTextStyle:
                                        TextStyle(color: Colors.black)),
                                calendarStyle: CalendarStyle(),
                                builders: CalendarBuilders(),
                              )),
                          // show full date of selected day
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, top: 10.0),
                            child: Text(
                              DateFormat("EEEE, dd MMMM, yyyy")
                                  .format(selectedDate),
                            ),
                          ),
                          ListView.builder(
                              // Scroll item inside scroll so => overflow => shrinkwrap true and physics on NeverScrollableScrollPhysics()
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              // determine how mutch events there are => #event of selected day
                              itemCount: _selectedEvents.length,
                              itemBuilder: (BuildContext context, int index) {
                                CalendarEvent event = _selectedEvents[index];
                                return ListTile(
                                  title: Text(event.title),
                                  subtitle: Text(
                                      DateFormat("EEEE, dd MMMM, yyyy")
                                          .format(event.date)),
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EventDetails(
                                              event: event,
                                            )),
                                  ),
                                  trailing: IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  AddEventPage(
                                                event: event,
                                              ),
                                            ),
                                          )),
                                  leading: IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () async {
                                      final confirm = await showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                    title: Text('Warning!'),
                                                    content: Text(
                                                        "Are you sure you want to delete?"),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context, true),
                                                        child: Text("Delete"),
                                                      ),
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context),
                                                        child: Text(
                                                          "Cancel",
                                                          style: TextStyle(
                                                            color: Colors
                                                                .grey.shade700,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )) ??
                                          false;
                                      if (confirm) {
                                        //validated so delete
                                        await eventDBS.removeItem(event.id);
                                      }
                                    },
                                  ),
                                );
                              }),
                        ],
                      );
                    }
                    return CircularProgressIndicator();
                  })
            ],
          ),
        ),
        //add new calendar event
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            //navigate with own routes => .pushNamed
            print("kurjahkuezhuklh");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    AddEventPage(selectedDate: _calendarController.selectedDay),
              ),
            );
          },
        ),
      );
    else {
      return Scaffold();
    }
  }
}
