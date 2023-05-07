import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:local_sheff/classes/user.dart';
import 'package:local_sheff/reusable_widgets/reusable_widget.dart';

import 'cus_home_screen.dart';

class CusRateHCScreen extends StatefulWidget {
  final AppUser appUser;
  final String homeCookReference;

  const CusRateHCScreen({Key? key, required this.appUser, required this.homeCookReference}) : super(key: key);

  @override
  State<CusRateHCScreen> createState() => _CusRateHCScreenState();
}

class _CusRateHCScreenState extends State<CusRateHCScreen> {
  TextEditingController _feedbackTextController = TextEditingController();

  Future<Uint8List?> loadImage(String url) async {
    final Reference ref =
    FirebaseStorage.instance.ref().child("users").child(url);
    const int maxSize = 10 * 1024 * 1024;
    final Uint8List? imageData = await ref.getData(maxSize);
    return imageData;
  }

  Widget returnImage(BuildContext context, String imageUrl) {
    return FutureBuilder<Uint8List?>(
      future: loadImage(imageUrl),
      builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return Image.memory(
            snapshot.data!,
            fit: BoxFit.cover,
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appUser = widget.appUser;
    final homeCookReference = widget.homeCookReference;
    double userRating = 3.0;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(20, 80, 20, 20),
            child: Column(children: <Widget>[
              Center(
                child: Text(
                  appUser.userName!,
                  style: const TextStyle(
                      fontSize: 25,
                      fontFamily: 'SFProDisplay',
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: MediaQuery.of(context).size.width * 0.6,
                  child: returnImage(context, appUser.imageReference!),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: RatingBar.builder(
                    initialRating: userRating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 40,
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      setState(() {
                        userRating = rating;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: TextField(
                        maxLines: 3,
                        controller: _feedbackTextController,
                        obscureText: false,
                        enableSuggestions: false,
                        autocorrect: false,
                        cursorColor: Colors.black,
                        style: const TextStyle(
                            color: Colors.black,
                            fontFamily: 'SFProDisplay',
                            fontSize: 18),
                        decoration: InputDecoration(
                          labelText: "Any Specific Feedback?",
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
                height: 10,
              ),
              reusableButton(context, "Submit Feedback", () async {
                final User? user = FirebaseAuth.instance.currentUser;
                final userID = user?.uid;

                FirebaseFirestore db = FirebaseFirestore.instance;

                String uniqueId = "DS${DateTime.now().millisecondsSinceEpoch}";

                //Create a Map of data
                Map<String, dynamic> dataToSend = {
                  'homeCookReference': homeCookReference,
                  'customerId': userID,
                  'rating': userRating,
                  'feedback': _feedbackTextController.text
                };

                db
                    .collection("feedback")
                    .doc(uniqueId)
                    .set(dataToSend)
                    .then((value) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CusHomeScreen()));
                }).catchError((err) {
                  print(err);
                });

              }, MediaQuery.of(context).size.width*0.8, 50)
            ]),
          )),
    );
  }
}
