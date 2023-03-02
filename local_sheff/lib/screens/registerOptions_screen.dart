import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:local_sheff/screens/signup_screen.dart';
import 'package:local_sheff/screens/start_screen.dart';

import '../reusable_widgets/reusable_widget.dart';

class RegisterOptionsScreen extends StatefulWidget {
  const RegisterOptionsScreen({super.key});

  @override
  State<RegisterOptionsScreen> createState() => _RegisterOptionsScreenState();
}

class _RegisterOptionsScreenState extends State<RegisterOptionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Column(children: <Widget>[
          const SizedBox(
            height: 150,
          ),
          const Text(
            "Register",
            style: TextStyle(
                fontSize: 30,
                fontFamily: 'SFProDisplay',
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "AS",
            style: TextStyle(
                fontSize: 18,
                fontFamily: 'SFProDisplay',
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
          const SizedBox(
            height: 30,
          ),
          resuableButton(context, 'CUSTOMER', () {
            StartScreen.typeOfCurrentUser = UserType.customer;
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignUpScreen()));
          }, MediaQuery.of(context).size.width * 0.7, 50),
          resuableButton(context, 'HOMECOOK', () {
            StartScreen.typeOfCurrentUser = UserType.homecook;
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignUpScreen()));
          }, MediaQuery.of(context).size.width * 0.7, 50),
          resuableButton(context, 'DELIVERY PERSON', () {
            StartScreen.typeOfCurrentUser = UserType.deliveryPerson;
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignUpScreen()));
          }, MediaQuery.of(context).size.width * 0.7, 50),
        ]),
      ),
    );
  }
}
