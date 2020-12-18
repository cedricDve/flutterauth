import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'Choose.dart';
import 'home.dart';
import 'package:flutter_familly_app/services/firebaseHelper.dart';

class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
    );

    return MaterialApp(
      title: 'Introduction screen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: OnBoardingPage(),
    );
  }
}

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();
  final FirebaseHelper _firebaseHelper = FirebaseHelper();
  bool isFamily = false;

  void _onIntroEndFirst(context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => Choose()),
    );
  }

  void _onIntroEnd(context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => Home()),
    );
  }

  Widget _buildImage(String assetName) {
    return Align(
      child: Image.asset('assets/images/$assetName.png', width: 350.0),
      alignment: Alignment.bottomCenter,
    );
  }

  @override
  void initState() {
    super.initState();
    _firebaseHelper.isFamilyId().then((value) {
      setState(() {
        isFamily = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    print(isFamily);

    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          title: "Welcome to Fami",
          body: "The application that connects your family !",
          image: _buildImage('famB'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Plan and Communicate easily",
          body: "Regroup images and write some familial posts",
          image: _buildImage('grandpa-ma'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Have a good moment and share it with your Family",
          body:
              "Fami focus on the security and privacy of our users, using Google Services and Cloud Storage.*",
          image: _buildImage('a'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Navigate easily with the bottom navigation-bar",
          body:
              "You can modify your profile and change your settings on the profile page. Pickup your avatar and choose from more than 50 pictures",
          image: _buildImage('nav'),
          footer: Container(
            child: Image.asset(
              'assets/images/avatars.png',
              height: 200,
            ),
            color: Colors.lightBlue,
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Let’s try it out !",
          bodyWidget: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("Start writing some family posts ", style: bodyStyle),
              SizedBox(height: 10),
              Icon(Icons.edit),
              SizedBox(height: 20),
              Text(
                  "Create some events and start a conversation with a family member",
                  style: bodyStyle),
              SizedBox(height: 20),
              Icon(Icons.message),
            ],
          ),
          image: _buildImage('famiLogo'),
          decoration: pageDecoration,
        ),
      ],
      onDone: (isFamily)
          ? () => _onIntroEnd(context)
          : () => _onIntroEndFirst(context),
      //onSkip: () => _onIntroEndFirst(context), // You can override onSkip callback
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      skip: const Text(
        'Skip',
        style: TextStyle(color: Color(0xFF90CAF9)),
      ),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
