// To access the firebase_auth
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_familly_app/main.dart';
import 'package:flutter_familly_app/once_loggedin.dart';

import 'package:provider/provider.dart';

import 'firebase_services/auth.dart';

//The method is asynchronous and returns a Future, so you need to ensure it has completed before displaying your main application.
Future<void> main() async {
  //init flutter-binding
  WidgetsFlutterBinding.ensureInitialized();
  //init. firebase app -> before use firebase services
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // "Provide Multiple things" -> class and user
    return MultiProvider(
      providers: [
        Provider<Auth>(
          create: (_) => Auth(FirebaseAuth.instance),
        ),
        //access auth service
        StreamProvider(
          create: (context) => context.read<Auth>().authStateChanges,
        ),
      ],
      child: MaterialApp(
        title: 'Login to start connect with your family',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: AuhtenticationWrapper(),
      ),
    );
  }
}

//return to home page or login page -> authenticated or not
class AuhtenticationWrapper extends StatelessWidget {
  const AuhtenticationWrapper({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //"listen to user"
    final firebaseUser = context.watch<User>();
    if (firebaseUser != null) {
      return OnceLoggedIn();

      ///logged in
    }
    return HomePage();
  }
}
