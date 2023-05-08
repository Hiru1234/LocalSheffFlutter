import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local_sheff/classes/dish.dart';
import 'package:local_sheff/classes/nutritionalInformation.dart';

class HcDishScreen extends StatefulWidget {
  final Dish dish;
  final NutritionalInformation nutritionalInfo;

  const HcDishScreen(
      {Key? key, required this.dish, required this.nutritionalInfo})
      : super(key: key);

  @override
  State<HcDishScreen> createState() => _HcDishScreenState();
}

class _HcDishScreenState extends State<HcDishScreen> {
  Future<Uint8List?> loadImage(String url) async {
    final Reference ref =
        FirebaseStorage.instance.ref().child("dishes").child(url);
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
    final dish = widget.dish;
    final nutritionalInfo = widget.nutritionalInfo;
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
                  dish.dishName!.toString(),
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
                  child: returnImage(context, dish.imageReference!),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "Price",
                      style: TextStyle(
                          fontSize: 21,
                          fontFamily: 'SFProDisplay',
                          color: Colors.black),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "£${dish.price}",
                      style: const TextStyle(
                          fontSize: 21,
                          fontFamily: 'SFProDisplay',
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                    child: Text(
                      dish.description!.toString(),
                      style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'SFProDisplay',
                          color: Colors.black),
                      textAlign: TextAlign.left,
                    ),
                  )),
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Text(
                      "Ingredients",
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'SFProDisplay',
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      textAlign: TextAlign.left,
                    ),
                  )),
              Align(
                alignment: Alignment.centerLeft,
                child: ListView.builder(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    shrinkWrap: true,
                    itemCount: dish.ingredients?.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: Text(
                          dish.ingredients![index],
                          style: const TextStyle(
                              fontSize: 20,
                              fontFamily: 'Roboto',
                              color: Colors.black),
                          textAlign: TextAlign.left,
                        ),
                      );
                    }),
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Text(
                        "Nutritional data :\n\n"
                        "   CHOCDF : ${nutritionalInfo.chocdf}\n"
                        "   ENERC_KCAL : ${nutritionalInfo.enercKcal}\n"
                        "   FAT : ${nutritionalInfo.fat}\n"
                        "   FIBTG : ${nutritionalInfo.fibtg}\n"
                        "   PROCNT : ${nutritionalInfo.procnt}\n",
                        style: const TextStyle(
                            color: Colors.black,
                            fontFamily: 'SFProDisplay',
                            fontSize: 17)),
                  )
              )
            ]),
          )),
    );
  }
}
