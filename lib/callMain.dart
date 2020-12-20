import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'package:flutter_familly_app/models/modelProvider.dart';

import 'package:flutter_familly_app/src/pages/index.dart';

import 'package:flutter_familly_app/src/pages/theme.dart';

import 'package:provider/provider.dart';

void main() => runApp(CallScreen());

class CallScreen extends StatefulWidget {
  @override
  CallScreenState createState() => CallScreenState();
}

class CallScreenState extends State<CallScreen> {
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();

  @override
  void initState() {
    super.initState();

    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
    await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        return themeChangeProvider;
      },
      child: Consumer<DarkThemeProvider>(
        builder: (BuildContext context, value, Widget child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: Styles.themeData(themeChangeProvider.darkTheme, context),
            home: IndexPage(),
          );
        },
      ),
    );
  }
}
