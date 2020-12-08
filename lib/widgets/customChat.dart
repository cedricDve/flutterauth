import 'package:flutter/material.dart';

class CustomChat extends StatelessWidget {
  final Widget leading;
  final Widget title;
  final Widget subtitle;
  final Widget icon;
  final Widget trailing;
  final bool mini;
  final GestureTapCallback onTap;
  final GestureLongPressCallback onLongPress;

  CustomChat({
    @required this.title,
    @required this.leading,
    @required this.subtitle,
    this.icon,
    this.trailing,
    this.onLongPress,
    this.mini = true,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        //make a re-usable "layout" for appending "chat-feed"
        //handeling two types of "ClickEvents": short and long Pression
        //make chat-feed: a circle image(user) | Title / Subtitle | Trailing
        onLongPress: onLongPress,
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: mini ? 10 : 0),
          child: Row(
            children: [
              //depending on (bool) mini => padding and marging >or<
              leading,
              Expanded(
                  child: Container(
                margin: EdgeInsets.only(left: mini ? 10 : 15),
                padding: EdgeInsets.symmetric(horizontal: mini ? 3 : 20),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(width: 1, color: Colors.blue))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        title,
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: <Widget>[
                            //if icon not null show icon otherwise show Container
                            icon ?? Container(),
                            subtitle,
                          ],
                        )
                      ],
                    ),
                    trailing ?? Container(),
                  ],
                ),
              ))
            ],
          ),
        ));
  }
}
