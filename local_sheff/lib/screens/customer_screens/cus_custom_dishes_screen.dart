import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local_sheff/reusable_widgets/reusable_widget.dart';
import 'package:local_sheff/screens/customer_screens/cus_custom_dish_screen.dart';

import '../../classes/customDish.dart';

class CusCustomDishesScreen extends StatefulWidget {
  const CusCustomDishesScreen({Key? key}) : super(key: key);

  @override
  State<CusCustomDishesScreen> createState() => _CusCustomDishesScreenState();
}

class _CusCustomDishesScreenState extends State<CusCustomDishesScreen> {

  Stream<List<CustomDish>> getOrders() {
    final User? user = FirebaseAuth.instance.currentUser;
    final userID = user?.uid;
    var data = FirebaseFirestore.instance
        .collection("customDishes")
        .where("customerId", isEqualTo: userID)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => CustomDish.fromJson(doc.data()))
        .toList());
    print("This is the stream : ${data.toList().toString()}");
    return data;
  }

  String returnOrderState(String orderState) {
    String state = "";
    switch (orderState) {
      case "CustomDishState.created":
        {
          state = "Created";
        }
        break;
      case "CustomDishState.accepted":
        {
          state = "Accepted";
        }
        break;
      case "CustomDishState.prepared":
        {
          state = "Prepared";
        }
        break;
      case "CustomDishState.completed":
        {
          state = "Completed";
        }
        break;
    }
    return state;
  }

  Widget buildDishes(CustomDish customDish) {
    return Container(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1.5, color: Colors.grey),
          ),
        ),
        child: ListTile(
          leading: const Icon(Icons.fastfood, color: standardGreenColor,),
          title: Text(
            customDish.dishName!,
            style: const TextStyle(
                color: Colors.black,
                fontFamily: 'SFProDisplay',
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
                  "${customDish.date} • ${returnOrderState(customDish.dishState!)}",
              style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'SFProDisplay',
                  fontSize: 16)),
          trailing: const Icon(Icons.receipt),
          onTap: ()  {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CusCustomDishScreen(customDish: customDish)));
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
                  "My Custom Dishes",
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
                child: StreamBuilder<List<CustomDish>>(
                  stream: getOrders(),
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
