import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:local_sheff/reusable_widgets/reusable_widget.dart';
import 'package:local_sheff/screens/delivery_person_screens/dp_delivery_screen.dart';
import 'package:local_sheff/screens/start_screen.dart';
import 'dart:convert';

import '../../classes/dishOrder.dart';
import '../../classes/user.dart';

class DpBrowseScreen extends StatefulWidget {
  const DpBrowseScreen({super.key});

  @override
  State<DpBrowseScreen> createState() => _DpBrowseScreenState();
}

class _DpBrowseScreenState extends State<DpBrowseScreen> {
  Stream<List<DishOrder>> getOrders() {
    var data = FirebaseFirestore.instance
        .collection("orders")
        .where("orderState", isEqualTo: OrderState.prepared.toString())
        .where("orderType", isEqualTo: OrderType.delivery.toString())
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => DishOrder.fromJson(doc.data()))
        .toList());
    print("This is the stream : ${data.toList().toString()}");
    return data;
  }

  void navigateToDeliveryScreen(BuildContext context, DishOrder order) async {
    //Gives error

    DatabaseReference referenceForHC = FirebaseDatabase.instance.ref("Users/${order.homeCookId}");
    DatabaseEvent eventForHC = await referenceForHC.once();
    Map<dynamic, dynamic>? userMap = eventForHC.snapshot.value as Map<dynamic, dynamic>?;

    Map<String, dynamic> convertedMap = {};
    userMap?.forEach((key, value) {
      if (key is String) {
        convertedMap[key] = value;
      }
    });

    AppUser homeCook = AppUser.fromJson(json.decode(json.encode(convertedMap)));


    // DatabaseReference referenceForCus = FirebaseDatabase.instance
    //     .ref("Users/${order.customerId}");
    // DatabaseEvent eventForCus = await referenceForCus.once();
    // AppUser customer = AppUser.fromSnapshot(eventForCus.snapshot);
    DatabaseReference referenceForCus = FirebaseDatabase.instance.ref("Users/${order.homeCookId}");
    DatabaseEvent eventForCus = await referenceForCus.once();
    Map<dynamic, dynamic>? userMapCus = eventForCus.snapshot.value as Map<dynamic, dynamic>?;

    Map<String, dynamic> convertedMapCus = {};
    userMapCus?.forEach((key, value) {
      if (key is String) {
        convertedMapCus[key] = value;
      }
    });

    AppUser customer = AppUser.fromJson(json.decode(json.encode(convertedMapCus)));

    CollectionReference collection =
    FirebaseFirestore.instance.collection('dishes');
    DocumentSnapshot snapshot =
    await collection.doc(order.dishId).get();
    String dishName = snapshot.get('dishName');

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DpDeliveryScreen(
              dishName: dishName, homeCook: homeCook, customer: customer, dishOrder: order,)));
  }

  String returnOrderState(String orderState) {
    String state = "";
    switch (orderState) {
      case "OrderState.placed":
        {
          state = "Placed";
        }
        break;
      case "OrderState.accepted":
        {
          state = "Accepted";
        }
        break;
      case "OrderState.prepared":
        {
          state = "Prepared";
        }
        break;
      case "OrderState.collectedByDriver":
        {
          state = "Collected";
        }
        break;
      case "OrderState.completed":
        {
          state = "Completed";
        }
        break;
    }
    return state;
  }

  Widget buildDishes(DishOrder order) {
    return Container(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1.5, color: Colors.grey),
          ),
        ),
        child: ListTile(
          leading: Icon(Icons.delivery_dining, color: standardGreenColor,),
          title: const Text(
            "Delivery",
            style: TextStyle(
                color: Colors.black,
                fontFamily: 'SFProDisplay',
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
              "${order.quantity} items • £${order.totalPrice}\n"
                  "${order.orderDate} • ${returnOrderState(order.orderState!)}",
              style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'SFProDisplay',
                  fontSize: 16)),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: ()  {
            navigateToDeliveryScreen(context, order);
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
                  "Deliveries",
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
                child: StreamBuilder<List<DishOrder>>(
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