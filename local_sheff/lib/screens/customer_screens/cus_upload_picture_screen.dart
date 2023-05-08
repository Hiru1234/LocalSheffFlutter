import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../../reusable_widgets/reusable_widget.dart';


class CusUploadPictureScreen extends StatefulWidget {
  const CusUploadPictureScreen({Key? key}) : super(key: key);

  @override
  State<CusUploadPictureScreen> createState() => _CusUploadPictureScreenState();
}

class _CusUploadPictureScreenState extends State<CusUploadPictureScreen> {
  File? selectedImage;
  String? foodName = "";
  dynamic nutritionalInformation;


  getFoodInformation() async {
    final request = http.MultipartRequest(
        "POST", Uri.parse("https://81e9-92-11-204-123.ngrok-free.app/predict_food"));
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
    nutritionalInformation = resJson['nutritional_information'];
    setState(() {});
  }

  Future getImage() async {
    final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery);
    selectedImage = File(pickedImage!.path);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: MediaQuery
            .of(context)
            .size
            .height,
        decoration: BoxDecoration(color: Colors.white),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery
                .of(context)
                .size
                .height * 0.2, 20, 0),
            child: Column(children: <Widget>[
              Container(
                color: Colors.white,
                child: const Text(
                  "Food Classification",
                  style: TextStyle(
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
              selectedImage == null
                  ? Text("Please pick an Image to Upload")
                  : Image.file(selectedImage!),
              const SizedBox(
                height: 20,
              ),
              TextButton.icon(onPressed: getImage,
                  icon: Icon(Icons.upload_file),
                  label: selectedImage == null
                      ? Text("Upload Image")
                      : Text("Change Image")),
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
              foodName == ""
                  ? Text("") : Text("Food name is $foodName\n Nutritional data are ${nutritionalInformation.toString()}")
            ]),
          ),
        ),
      ),
    );
  }
}
