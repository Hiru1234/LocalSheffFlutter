//import 'package:flutter/src/widgets/framework.dart';
//import 'package:flutter/src/widgets/placeholder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:local_sheff/screens/customer_screens/home_screen.dart';
import 'package:local_sheff/screens/resetPassword_screen.dart';
import 'package:local_sheff/screens/signup_screen.dart';

import '../reusable_widgets/reusable_widget.dart';

//const backgroundColor = Color(0xff0CE78A);

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _passwordTextController = TextEditingController();
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
              reusableTextField("Enter Username", Icons.person_outline, false,
                  _userNameTextController),
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
                        email: _userNameTextController.text,
                        password: _passwordTextController.text)
                    .then((value) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeScreen()));
                }).catchError((onError){
                  showDialog(context: context, builder: (BuildContext context){
                    return AlertDialog(
                      title: Text("Error"),
                      content: Text(onError.toString()),
                      actions: [
                        ElevatedButton(onPressed: () {
                          Navigator.of(context).pop();
                        }, child: Text("Ok"))
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

  Widget forgotPassword(BuildContext context){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 35,
      alignment: Alignment.bottomLeft,
      child: TextButton(
        child: const Text("Forgot Password?",
          style: TextStyle(color: Colors.black, fontFamily: 'SFProDisplay'),
          textAlign: TextAlign.left,
        ),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPasswordScreen()));
        },
      ),
    );
  }
}
