import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local_sheff/screens/customer_screens/cus_home_screen.dart';

import '../../reusable_widgets/reusable_widget.dart';

class CusCreateCustomDishScreen extends StatefulWidget {
  const CusCreateCustomDishScreen({Key? key}) : super(key: key);

  @override
  State<CusCreateCustomDishScreen> createState() => _CusCreateCustomDishScreenState();
}

class _CusCreateCustomDishScreenState extends State<CusCreateCustomDishScreen> {
  final TextEditingController _instructionsTextController = TextEditingController();
  final TextEditingController _dishNameTextController = TextEditingController();
  final TextEditingController _emailTextController =
  TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(color: Colors.white),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.1, 20, 0),
            child: Column(children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  color: Colors.white,
                  child: const Text(
                    "Create Your Very Own Dish!",
                    style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'SFProDisplay',
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text("You can now create your very own dish for our qualified home cooks to prepare for you. Just describe what you want and post it in the app!",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'SFProDisplay',
                  fontSize: 17,
                ),),
              const SizedBox(
                height: 30,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    color: Colors.white,
                    child: TextField(
                      controller: _dishNameTextController,
                      obscureText: false,
                      enableSuggestions: false,
                      autocorrect: false,
                      cursorColor: Colors.black,
                      style: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'SFProDisplay',
                          fontSize: 18),
                      decoration: InputDecoration(
                        labelText: "Dish Name",
                        labelStyle: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'SFProDisplay',
                          fontSize: 22,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                                width: 2, style: BorderStyle.solid)),
                      ),
                      keyboardType: TextInputType.name,
                    )),
              ),
              const SizedBox(
                height: 30,
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: TextField(
                        maxLines: 3,
                        controller: _instructionsTextController,
                        obscureText: false,
                        enableSuggestions: false,
                        autocorrect: false,
                        cursorColor: Colors.black,
                        style: const TextStyle(
                            color: Colors.black,
                            fontFamily: 'SFProDisplay',
                            fontSize: 18),
                        decoration: InputDecoration(
                          labelText: "How would you like it prepared?",
                          labelStyle: const TextStyle(
                            color: Colors.black,
                            fontFamily: 'SFProDisplay',
                            fontSize: 22,
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  width: 2, style: BorderStyle.solid)),
                        ),
                        keyboardType: TextInputType.name,
                      ))),
              const SizedBox(
                height: 30,
              ),
              const Text("Stay in touch regarding any updates about your dish!",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'SFProDisplay',
                  fontSize: 17,
                ),),
              const SizedBox(
                height: 30,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    color: Colors.white,
                    child: TextField(
                      controller: _emailTextController,
                      obscureText: false,
                      enableSuggestions: false,
                      autocorrect: false,
                      cursorColor: Colors.black,
                      style: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'SFProDisplay',
                          fontSize: 18),
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'SFProDisplay',
                          fontSize: 22,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                                width: 2, style: BorderStyle.solid)),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    )),
              ),
              const SizedBox(
                height: 30,
              ),
              reusableButton(context, "Create Dish", () async {
                if (_dishNameTextController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                        'Please provide a dish Name',
                        style: TextStyle(
                          fontFamily: 'SFProDisplay',
                          fontSize: 17,
                        ),
                      )));
                  return;
                }
                if (_instructionsTextController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                        'Please give us more instructions',
                        style: TextStyle(
                          fontFamily: 'SFProDisplay',
                          fontSize: 17,
                        ),
                      )));
                  return;
                }
                if (_emailTextController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                        'Please provide an email for correspondence',
                        style: TextStyle(
                          fontFamily: 'SFProDisplay',
                          fontSize: 17,
                        ),
                      )));
                  return;
                }

                String uniqueFileName =
                DateTime.now().millisecondsSinceEpoch.toString();

                final User? user = FirebaseAuth.instance.currentUser;
                final userID = user?.uid;

                FirebaseFirestore db = FirebaseFirestore.instance;

                String uniqueId = "DS${DateTime.now().millisecondsSinceEpoch}";

                DateTime now = DateTime.now();
                String formattedDate = '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';


                //Create a Map of data
                Map<String, dynamic> dataToSend = {
                  'dishName': _dishNameTextController.text,
                  'instructions': _instructionsTextController.text,
                  'email': _emailTextController.text,
                  'customerId':userID,
                  'dishState': CustomDishState.created.toString(),
                  'homeCookId':'',
                  'date': formattedDate,
                  'customDishId': uniqueId
                };

                db
                    .collection("customDishes")
                    .doc(uniqueId)
                    .set(dataToSend)
                    .then((value) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CusHomeScreen()));
                }).catchError((err) {
                  print(err);
                });
                //Add a new item
              }, MediaQuery.of(context).size.width, 50)
            ]),
          ),
        ),
      ),
    );
  }
}
