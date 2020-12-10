import 'package:flutter/material.dart';
import 'package:flutter_familly_app/models/events.dart';

class EventDetails extends StatelessWidget {
  final Events events;

  const EventDetails({Key key, this.events}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 300),
                        Text(
                          events.title,
                          style: TextStyle(
                            fontFamily: 'Avenir',
                            fontSize: 56,
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          '08-12-2020',
                          style: TextStyle(
                            fontFamily: 'Avenir',
                            fontSize: 31,
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Divider(color: Colors.white),
                        SizedBox(height: 32),
                        Text(
                          events.description ?? '',
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Avenir',
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 32),
                        Divider(color: Colors.white),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 32.0),
                    child: Text(
                      'Gallery',
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        fontSize: 25,
                        color: const Color(0xff47455f),
                        fontWeight: FontWeight.w300,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    height: 250,
                    padding: const EdgeInsets.only(left: 32.0),
                    child: ListView.builder(
                        itemCount: events.images.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Card(
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: Image.network(
                                events.images[index],
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
            Positioned(
              right: -50,
              width: 260,
              height: 260,
              child: Hero(
                  tag: events.position, child: Image.network(events.avatar)),
            ),
            Positioned(
              top: 60,
              left: 32,
              child: Text(
                events.position.toString(),
                style: TextStyle(
                  fontFamily: 'Avenir',
                  fontSize: 200,
                  color: Colors.black.withOpacity(0.08),
                  fontWeight: FontWeight.w900,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
