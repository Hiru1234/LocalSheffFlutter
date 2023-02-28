import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:local_sheff/reusable_widgets/reusable_widget.dart';
import 'package:local_sheff/screens/registerOptions_screen.dart';
import 'package:local_sheff/screens/signin_screen.dart';
import 'package:local_sheff/screens/signup_screen.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(color: standardGreenColor),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.3, 20, 0),
            child: Column(children: <Widget>[
              logoWidget("assets/images/LocalSheff_logo.jpeg"),
              const SizedBox(
                height: 250,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                resuableButton(context, 'SIGN IN', () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SignInScreen()));
              }, 170, 50),
              const SizedBox(
                width: 10,
              ),
              resuableButton(context, 'REGISTER', () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterOptionsScreen()));
              }, 170, 50),
              ],),
            ]),
          ),
        ),
      ),
    );
  }
}