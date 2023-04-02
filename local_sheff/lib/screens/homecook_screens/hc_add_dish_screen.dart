import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_sheff/reusable_widgets/reusable_widget.dart';
import 'dart:io';
import 'dart:core';

import 'hc_home_screen.dart';

class HcAddDishScreen extends StatefulWidget {
  const HcAddDishScreen({Key? key}) : super(key: key);

  @override
  State<HcAddDishScreen> createState() => _HcAddDishScreenState();
}

class _HcAddDishScreenState extends State<HcAddDishScreen> {
  final List<String> ingredients = <String>[];
  final TextEditingController _dishNameTextController = TextEditingController();
  final TextEditingController _descriptionTextController =
      TextEditingController();
  final TextEditingController _ingredientTextController =
      TextEditingController();
  bool displayList = false;
  String imageUrl = '';
  ImagePicker imagePicker = ImagePicker();
  XFile? file = XFile("");

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
                    "Create Dish",
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
                height: 40,
              ),
              IconButton(
                  onPressed: () async {
                    /*
                * Step 1. Pick/Capture an image   (image_picker)
                * Step 2. Upload the image to Firebase storage
                * Step 3. Get the URL of the uploaded image
                * Step 4. Store the image URL inside the corresponding
                *         document of the database.
                * Step 5. Display the image on the list
                *
                * */

                    /*Step 1:Pick image*/
                    //Install image_picker
                    //Import the corresponding library

                    //ImagePicker imagePicker = ImagePicker();
                    await pickImage();
                  },
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  icon: const Icon(Icons.camera_alt)),
              const SizedBox(
                height: 40,
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
                      onChanged: (val) {
                        isListEmpty();
                      },
                    )),
              ),
              const SizedBox(
                height: 40,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    color: Colors.white,
                    child: TextField(
                      controller: _descriptionTextController,
                      obscureText: false,
                      enableSuggestions: false,
                      autocorrect: false,
                      cursorColor: Colors.black,
                      style: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'SFProDisplay',
                          fontSize: 18),
                      decoration: InputDecoration(
                        labelText: "Description",
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      width: 170,
                      height: 50,
                      color: Colors.white,
                      child: TextField(
                        controller: _ingredientTextController,
                        obscureText: false,
                        enableSuggestions: false,
                        autocorrect: false,
                        cursorColor: Colors.black,
                        style: const TextStyle(
                            color: Colors.black,
                            fontFamily: 'SFProDisplay',
                            fontSize: 18),
                        decoration: InputDecoration(
                          labelText: "Ingredient",
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
                  const SizedBox(
                    width: 10,
                  ),
                  reusableButton(context, "Add Ingredient", () {
                    ingredients.add(_ingredientTextController.text);
                    displayList = true;
                    isListEmpty();
                  }, 170, 50)
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  color: Colors.white,
                  child: const Text(
                    "Ingredients",
                    style: TextStyle(
                        fontSize: 22,
                        fontFamily: 'SFProDisplay',
                        color: Colors.black),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    shrinkWrap: true,
                    itemCount: ingredients.length,
                    itemBuilder: (context, index) {
                      return Text(
                        ingredients[index],
                        style: const TextStyle(
                            fontSize: 20,
                            fontFamily: 'SFProDisplay',
                            fontStyle: FontStyle.italic,
                            color: Colors.black),
                        textAlign: TextAlign.left,
                      );
                    }),
              ),
              const SizedBox(
                height: 30,
              ),
              reusableButton(context, "Create Dish", () async {
                if (imageUrl.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please upload an image')));

                  return;
                }

                //Import dart:core
                String uniqueFileName =
                DateTime.now().millisecondsSinceEpoch.toString();

                /*Step 2: Upload to Firebase storage*/
                //Install firebase_storage
                //Import the library

                //Get a reference to storage root
                Reference referenceRoot = FirebaseStorage.instance.ref();
                Reference referenceDirImages =
                referenceRoot.child('dishes');

                //Create a reference for the image to be stored
                Reference referenceImageToUpload =
                referenceDirImages.child(uniqueFileName);

                //Handle errors/success
                try {
                  //Store the file
                  await referenceImageToUpload.putFile(File(file!.path));
                  //Success: get the download URL
                  imageUrl = await referenceImageToUpload.getDownloadURL();
                } catch (error) {
                  //Some error occurred
                  print(error.toString());
                }

                String dishName = _dishNameTextController.text;
                String description = _descriptionTextController.text;

                final User? user = FirebaseAuth.instance.currentUser;
                final userID = user?.uid;

                FirebaseFirestore db = FirebaseFirestore.instance;

                String uniqueId =
                "DS${DateTime.now().millisecondsSinceEpoch}";

                //Create a Map of data
                Map<String, dynamic> dataToSend = {
                  'dishName': dishName,
                  'description': description,
                  'ingredients': ingredients,
                  'imageReference': imageUrl,
                  'homeCookReference': userID
                };

                db.collection("dishes")
                    .doc(uniqueId)
                    .set(dataToSend)
                    .onError((e, _) => print("Error writing document: $e"));

                //Add a new item
              }, MediaQuery.of(context).size.width, 50)
            ]),
          ),
        ),
      ),
    );
  }

  Future pickImage() async {
    XFile? pickedFile =
    await imagePicker.pickImage(source: ImageSource.gallery);
    print('This file path ${file?.path}');

    if (file == null) return;
    //final pickedFile = await imagePicker.getImage(source: ImageSource.camera);

    setState(() {
      file = pickedFile;
      print('This file path ${pickedFile?.path}');
    });
  }

  bool isListEmpty() {
    setState(() {
      if (ingredients.isNotEmpty) {
        displayList = true;
      }
    });
    return displayList;
  }
}
