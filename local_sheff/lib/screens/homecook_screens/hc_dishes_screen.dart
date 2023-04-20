import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:local_sheff/classes/dish.dart';

class HcDishesScreen extends StatefulWidget {
  const HcDishesScreen({Key? key}) : super(key: key);

  @override
  State<HcDishesScreen> createState() => _HcDishesScreenState();
}

class _HcDishesScreenState extends State<HcDishesScreen> {
  Stream<List<Dish>> getDishes() {
    final User? user = FirebaseAuth.instance.currentUser;
    final userID = user?.uid;
    var data = FirebaseFirestore.instance.collection("dishes").where("homeCookReference", isEqualTo: userID).snapshots().map(
            (snapshot) =>
            snapshot.docs.map((doc) => Dish.fromJson(doc.data())).toList());
    print("This is the stream : ${data.toList().toString()}");
    return data;
  }

  Future<Uint8List?> loadImage(String url) async {
    final Reference ref = FirebaseStorage.instance.ref().child("dishes").child(url);
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

  Widget buildDishes(Dish dish) {
    return Container(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1.5, color: Colors.grey),
          ),
        ),
        child: ListTile(
          leading: ClipOval(
            child: SizedBox.fromSize(
                size: Size.fromRadius(30), // Image radius
                child: returnImage(context, dish.imageReference!)),
          ),
          title: Text(
            dish.dishName!,
            style: const TextStyle(
                color: Colors.black,
                fontFamily: 'SFProDisplay',
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          trailing: const Icon(Icons.more_vert_outlined),
          onTap: () {
            showGeneralDialog(
              barrierDismissible: false,
              transitionDuration: const Duration(milliseconds: 200),
              context: context,
              pageBuilder: (BuildContext context, Animation animation,
                  Animation secondAnimation) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  contentPadding: EdgeInsets.fromLTRB(20, 30, 20, 10),
                  scrollable: true,
                  content: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: SingleChildScrollView(
                        child: Column(children: <Widget>[
                          Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                                child: IconButton(
                                  icon: const Icon(Icons.close_outlined),
                                  color: Colors.black,
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              )
                          ),
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
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
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
                                  return ListTile(
                                    contentPadding:
                                    EdgeInsets.symmetric(vertical: 4.0),
                                    dense: true,
                                    title: Text(
                                      dish.ingredients?[index],
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'SFProDisplay',
                                          color: Colors.black),
                                      textAlign: TextAlign.left,
                                    ),
                                  );
                                }),
                          ),
                        ]),
                      )),
                );
              },
            );
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(color: Colors.white),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              20, MediaQuery.of(context).size.height * 0.08, 20, 0),
          child: Column(children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                color: Colors.white,
                child: const Text(
                  "My Dishes",
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
            Expanded(
                child: StreamBuilder<List<Dish>>(
                  stream: getDishes(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text("");
                    } else if (snapshot.hasData) {
                      final dishes = snapshot.data!;
                      return ListView(
                        padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                        children: dishes.map(buildDishes).toList(),
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                )),
          ]),
        ),
      ),
    );
  }
}


