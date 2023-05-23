import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_sheff/classes/nutritionalInformation.dart';
import 'package:local_sheff/reusable_widgets/reusable_widget.dart';
import 'dart:io';
import 'dart:core';

import 'hc_home_screen.dart';
import 'package:http/http.dart' as http;

class HcAddDishScreen extends StatefulWidget {
  const HcAddDishScreen({Key? key}) : super(key: key);

  @override
  State<HcAddDishScreen> createState() => _HcAddDishScreenState();
}

class _HcAddDishScreenState extends State<HcAddDishScreen> {
  final List<String> ingredients = <String>[];
  final TextEditingController _priceTextController = TextEditingController();
  final TextEditingController _dishNameTextController = TextEditingController();
  final TextEditingController _descriptionTextController =
      TextEditingController();
  final TextEditingController _ingredientTextController =
      TextEditingController();
  bool displayList = false;
  File? selectedImage;
  String? imageUrl = "";
  String? foodName = "";
  //Map<String, dynamic> nutritionalInformation = {};
  NutritionalInformation? nutritionalInfo;


  getFoodInformation() async {
    final request = http.MultipartRequest(
        "POST", Uri.parse("https://c5e3-92-11-204-123.ngrok-free.app/predict_food"));
    final headers = {"Content-type": "multipart/form-data"};

    request.files.add(http.MultipartFile('image',
        selectedImage !.readAsBytes().asStream(), selectedImage !.lengthSync(),
        filename: selectedImage !
            .path
            .split("/")
            .last));

    request.headers.addAll(headers);
    final response = await request.send();
    http.Response res = await http.Response.fromStream(response);
    final resJson = jsonDecode(res.body);
    foodName = resJson['food_name'];
    Map<String, dynamic> nutritionalInformation = resJson['nutritional_information'];
    nutritionalInfo = NutritionalInformation.fromJson(nutritionalInformation);
    setState(() {});
  }

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
              selectedImage == null
                  ? const Text(
                      "Please pick an image to upload",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'SFProDisplay',
                        fontSize: 17,
                      ),
                    )
                  : Image.file(selectedImage!),
              TextButton.icon(
                  onPressed: getImage,
                  icon: const Icon(Icons.upload_file),
                  label: selectedImage == null
                      ? const Text(
                          "Upload Image",
                          style: TextStyle(
                            fontFamily: 'SFProDisplay',
                            fontSize: 17,
                          ),
                        )
                      : const Text(
                          "Change Image",
                          style: TextStyle(
                            fontFamily: 'SFProDisplay',
                            fontSize: 17,
                          ),
                        )),

              const SizedBox(
                height: 20,
              ),
              if(selectedImage != null)
                reusableButton(context, "Get Nutritional Information", () {
                  getFoodInformation();
                }, MediaQuery
                    .of(context)
                    .size
                    .width, 50),
              const SizedBox(
                height: 20,
              ),
              if(foodName == "")
                const Text("")
              else
                Text("Predicted Food Name : $foodName\n\n"
                    "Nutritional data are\n"
                    "   CHOCDF : ${nutritionalInfo?.chocdf}\n"
                    "   ENERC_KCAL : ${nutritionalInfo?.enercKcal}\n"
                    "   FAT : ${nutritionalInfo?.fat}\n"
                    "   FIBTG : ${nutritionalInfo?.fibtg}\n"
                    "   PROCNT : ${nutritionalInfo?.procnt}\n",
                    style: const TextStyle(
                        color: Colors.black,
                        fontFamily: 'SFProDisplay',
                        fontSize: 17)
                ),
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
                      onChanged: (val) {
                        isListEmpty();
                      },
                    )),
              ),
              const SizedBox(
                height: 30,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    color: Colors.white,
                    child: TextField(
                      controller: _priceTextController,
                      obscureText: false,
                      enableSuggestions: false,
                      autocorrect: false,
                      cursorColor: Colors.black,
                      style: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'SFProDisplay',
                          fontSize: 18),
                      decoration: InputDecoration(
                        labelText: "Price",
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
                height: 30,
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
                if (selectedImage == null) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                    'Please upload an image',
                    style: TextStyle(
                      fontFamily: 'SFProDisplay',
                      fontSize: 17,
                    ),
                  )));
                  return;
                }
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
                if (_priceTextController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                        'Please provide a price for the dish',
                        style: TextStyle(
                          fontFamily: 'SFProDisplay',
                          fontSize: 17,
                        ),
                      )));
                  return;
                }
                if (_descriptionTextController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                    'Please provide a description for the dish',
                    style: TextStyle(
                      fontFamily: 'SFProDisplay',
                      fontSize: 17,
                    ),
                  )));
                  return;
                }
                if (ingredients.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                    'Please provide ingredients for the dish',
                    style: TextStyle(
                      fontFamily: 'SFProDisplay',
                      fontSize: 17,
                    ),
                  )));
                  return;
                }

                String uniqueFileName =
                    DateTime.now().millisecondsSinceEpoch.toString();

                //Get a reference to storage root
                Reference referenceRoot = FirebaseStorage.instance.ref();
                Reference referenceDirImages = referenceRoot.child('dishes');

                //Create a reference for the image to be stored
                Reference referenceImageToUpload =
                    referenceDirImages.child(uniqueFileName);

                //Handle errors/success
                try {
                  //Store the file
                  await referenceImageToUpload
                      .putFile(File(selectedImage!.path));
                  //Success: get the download URL
                  //imageUrl = await referenceImageToUpload.getDownloadURL();
                } catch (error) {
                  //Some error occurred
                  print(error.toString());
                }

                final User? user = FirebaseAuth.instance.currentUser;
                final userID = user?.uid;

                FirebaseFirestore db = FirebaseFirestore.instance;

                String uniqueId = "DS${DateTime.now().millisecondsSinceEpoch}";

                Map<String, dynamic>? json = NutritionalInformation.toJson(nutritionalInfo!);

                //Create a Map of data
                Map<String, dynamic> dataToSend = {
                  'dishName': _dishNameTextController.text,
                  'price': _priceTextController.text,
                  'description': _descriptionTextController.text,
                  'ingredients': ingredients,
                  'imageReference': uniqueFileName,
                  'homeCookReference': userID,
                  'nutritionalInformation':json
                };

                db
                    .collection("dishes")
                    .doc(uniqueId)
                    .set(dataToSend)
                    .then((value) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HCHomeScreen()));
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

  Future getImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    selectedImage = File(pickedImage!.path);
    setState(() {});
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
