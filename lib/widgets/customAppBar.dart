import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  //creating custom appbar -> using var to re-use and have different implementations of our customAppbar
  final Widget title;
  final List<Widget> actions;
  final Widget leading;
  final bool centerTitle;
  CustomAppBar({
    Key key,
    this.title,
    this.actions,
    this.leading,
    this.centerTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: Colors.black,
          border: Border(
              bottom: BorderSide(
                  color: Colors.blue, width: 1.2, style: BorderStyle.solid))),
      child: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: leading,
        actions: actions,
        centerTitle: centerTitle,
        title: title,
      ),
    );
  }

  //override preferredSize
  final Size preferredSize = const Size.fromHeight(kToolbarHeight + 10);
}
