import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:local_sheff/classes/dish.dart';
import 'package:local_sheff/classes/user.dart';
import 'package:local_sheff/screens/customer_screens/cus_dish_screen.dart';

class CusBrowseScreen extends StatefulWidget {
  const CusBrowseScreen({super.key});

  @override
  State<CusBrowseScreen> createState() => _CusBrowseScreenState();
}

class _CusBrowseScreenState extends State<CusBrowseScreen> {
  TextEditingController _dishTextController = TextEditingController();
  Stream<List<Dish>>? _dishStream;
  String searchResult = "";

  Stream<List<Dish>> getDishes() {
    var data = FirebaseFirestore.instance.collection("dishes").snapshots().map(
        (snapshot) =>
            snapshot.docs.map((doc) => Dish.fromJson(doc.data())).toList());
    print("This is the stream : ${data.toList().toString()}");
    return data;
  }

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
            DatabaseReference reference =
            FirebaseDatabase.instance.ref("Users/${dish.homeCookReference}");
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return FutureBuilder<DatabaseEvent>(
                  future: reference.once(),
                  builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                      AppUser appUser = AppUser.fromSnapshot(snapshot.data!.snapshot);
                      return CusDishScreen(dish: dish, appUser: appUser);
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                );
              }),
            );
          },
        ));
  }

  @override
  void initState() {
    super.initState();
    _dishStream = getDishes();
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
                  "Discover",
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
            Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: TextField(
                    controller: _dishTextController,
                    onChanged: (value) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.black,
                        ),
                        labelText: "Search Dishes",
                        labelStyle: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'SFProDisplay',
                          fontSize: 16,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                                width: 0, style: BorderStyle.solid))),
                  ),
                )),
            Expanded(
                child: StreamBuilder<List<Dish>>(
              stream: _dishStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text("");
                } else if (snapshot.hasData) {
                  final dishes = snapshot.data!;
                  //final data = snapshot.data!;
                  final query = _dishTextController.text.trim().toLowerCase();

                  final filteredDishes = query.isEmpty
                      ? dishes
                      : dishes.where((item) => item.dishName!.toLowerCase().contains(query)).toList();
                  return ListView(
                    padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                    children: filteredDishes.map(buildDishes).toList(),
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
