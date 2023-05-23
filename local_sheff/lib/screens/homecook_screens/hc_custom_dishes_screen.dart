import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local_sheff/screens/homecook_screens/hc_custom_dish_screen.dart';

import '../../classes/customDish.dart';
import '../../reusable_widgets/reusable_widget.dart';

class HcCustomDishesScreen extends StatefulWidget {
  const HcCustomDishesScreen({Key? key}) : super(key: key);

  @override
  State<HcCustomDishesScreen> createState() => _HcCustomDishesScreenState();
}

class _HcCustomDishesScreenState extends State<HcCustomDishesScreen> {
  Stream<List<CustomDish>> getOrders() {
    var data = FirebaseFirestore.instance
        .collection("customDishes")
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

  void navigateToCustomOrderScreen(BuildContext context, CustomDish customOrder) async {
    DatabaseReference referenceForName = FirebaseDatabase.instance
        .ref("Users/${customOrder.customerId}/userName");
    DatabaseEvent eventForName = await referenceForName.once();
    String customerName = eventForName.snapshot.value.toString();

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HCustomDishScreen(customDish: customOrder, customerName: customerName)));
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
            navigateToCustomOrderScreen(context,customDish);
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
                  "Customer Custom Dishes",
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
