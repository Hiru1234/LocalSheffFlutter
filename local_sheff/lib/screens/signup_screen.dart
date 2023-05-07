import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:local_sheff/screens/customer_screens/cus_home_screen.dart';
import 'package:local_sheff/screens/delivery_person_screens/dp_browse_screen.dart';
import 'package:local_sheff/screens/delivery_person_screens/dp_home_screen.dart';
import 'package:local_sheff/screens/homecook_screens/hc_home_screen.dart';
import 'package:local_sheff/screens/registerOptions_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:local_sheff/screens/start_screen.dart';

import '../reusable_widgets/reusable_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final databaseReference = FirebaseDatabase.instance.ref().child("Users");

  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _userNameTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(color: Colors.white),
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
                    "Register",
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
              reusableTextField("Enter Username", Icons.person_outline, false,
                  _userNameTextController),
              const SizedBox(
                height: 20,
              ),
              reusableTextField("Enter Email", Icons.person_outline, false,
                  _emailTextController),
              const SizedBox(
                height: 20,
              ),
              reusableTextField("Enter Password", Icons.lock_outline, true,
                  _passwordTextController),
              const SizedBox(
                height: 20,
              ),
              reusableButton(context, 'REGISTER', () {
                FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                        email: _emailTextController.text,
                        password: _passwordTextController.text)
                    .then((value) {
                  print("Created new account");
                  StartScreen.nameOfCurrentUser = _userNameTextController.text;
                  final User? user = FirebaseAuth.instance.currentUser;
                  final userID = user?.uid;
                  databaseReference.child(userID!).set({
                    'userName': _userNameTextController.text,
                    'userEmail': _emailTextController.text,
                    'role': StartScreen.typeOfCurrentUser.toString(),
                    'image': "",
                    'postcode':"",
                  });

                  switch (StartScreen.typeOfCurrentUser) {
                    case UserType.customer:
                      {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CusHomeScreen()));
                      }
                      break;
                    case UserType.homecook:
                      {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HCHomeScreen()));
                      }
                      break;
                    case UserType.deliveryPerson:
                      {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DpHomeScreen()));
                      }
                      break;
                  }
                }).catchError((err) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Error",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'SFProDisplay')),
                          content: Text(
                              textValidator(_emailTextController.text,
                                  _passwordTextController.text),
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
}
