//import 'package:flutter/src/widgets/framework.dart';
//import 'package:flutter/src/widgets/placeholder.dart';
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:local_sheff/screens/customer_screens/cus_home_screen.dart';
import 'package:local_sheff/screens/delivery_person_screens/dp_browse_screen.dart';
import 'package:local_sheff/screens/homecook_screens/hc_home_screen.dart';
import 'package:local_sheff/screens/resetPassword_screen.dart';
import 'package:local_sheff/screens/signup_screen.dart';
import 'package:local_sheff/screens/start_screen.dart';

import '../reusable_widgets/reusable_widget.dart';

//const backgroundColor = Color(0xff0CE78A);

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  //final databaseReference = FirebaseDatabase.instance.ref().child("Users");

  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(color: Colors.white),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.2, 20, 0),
            child: Column(children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  color: Colors.white,
                  child: const Text(
                    "Log in",
                    style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'SFProDisplay',
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              reusableTextField("Enter Email Id", Icons.person_outline, false,
                  _emailTextController),
              const SizedBox(
                height: 20,
              ),
              reusableTextField("Enter Password", Icons.lock_outline, true,
                  _passwordTextController),
              const SizedBox(
                height: 20,
              ),
              forgotPassword(context),
              const SizedBox(
                height: 20,
              ),
              resuableButton(context, 'SIGN IN', () {
                FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                        email: _emailTextController.text,
                        password: _passwordTextController.text)
                    .then((value) async {
                  final User? user = FirebaseAuth.instance.currentUser;
                  final userID = user?.uid;
                  DatabaseReference referenceForName =
                      FirebaseDatabase.instance.ref("Users/$userID/userName");
                  DatabaseEvent eventForName = await referenceForName.once();
                  StartScreen.nameOfCurrentUser = eventForName.snapshot.value.toString();
                  DatabaseReference referenceForRole =
                      FirebaseDatabase.instance.ref("Users/$userID/role");
                  DatabaseEvent eventForRole = await referenceForRole.once();
                  String currentUserType = eventForRole.snapshot.value.toString();
                  switch (currentUserType) {
                    case "UserType.customer":
                      {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CusHomeScreen()));
                      }
                      break;
                    case "UserType.homecook":
                      {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HCHomeScreen()));
                      }
                      break;
                    case "UserType.deliveryPerson":
                      {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DPHomePage()));
                      }
                      break;
                  }
                }).catchError((onError) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Error",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'SFProDisplay')),
                          content: Text(onError.toString(),
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'SFProDisplay')),
                          actions: [
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: standardGreyColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                ),
                                child: const Text("Ok",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'SFProDisplay')))
                          ],
                        );
                      });
                });
              }, MediaQuery.of(context).size.width, 50),
            ]),
          ),
        ),
      ),
    );
  }

  Widget forgotPassword(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 35,
      alignment: Alignment.bottomLeft,
      child: TextButton(
        child: const Text(
          "Forgot Password?",
          style: TextStyle(color: Colors.black, fontFamily: 'SFProDisplay'),
          textAlign: TextAlign.left,
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ResetPasswordScreen()));
        },
      ),
    );
  }
}
