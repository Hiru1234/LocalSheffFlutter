import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local_sheff/screens/homecook_screens/hc_due_order_screen.dart';

import '../../classes/dishOrder.dart';

class HcDueOrdersScreen extends StatefulWidget {
  const HcDueOrdersScreen({Key? key}) : super(key: key);

  @override
  State<HcDueOrdersScreen> createState() => _HcDueOrdersScreenState();
}

class _HcDueOrdersScreenState extends State<HcDueOrdersScreen> {
  Stream<List<DishOrder>> getOrders() {
    final User? user = FirebaseAuth.instance.currentUser;
    final userID = user?.uid;
    var data = FirebaseFirestore.instance
        .collection("orders")
        .where("homeCookId", isEqualTo: userID)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => DishOrder.fromJson(doc.data()))
        .toList());
    print("This is the stream : ${data.toList().toString()}");
    return data;
  }

  Future<Uint8List?> loadImage(String url) async {
    CollectionReference collection =
    FirebaseFirestore.instance.collection('dishes');
    DocumentSnapshot snapshot = await collection.doc(url).get();
    String fieldData = snapshot.get('imageReference');
    final Reference ref =
    FirebaseStorage.instance.ref().child("dishes").child(fieldData);
    const int maxSize = 10 * 1024 * 1024;
    final Uint8List? imageData = await ref.getData(maxSize);
    return imageData;
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
  void navigateToHcOrderScreen(BuildContext context, DishOrder order) async {
    DatabaseReference referenceForName = FirebaseDatabase.instance
        .ref("Users/${order.homeCookId}/userName");
    DatabaseEvent eventForName = await referenceForName.once();
    String homeCookName = eventForName.snapshot.value.toString();

    CollectionReference collection =
    FirebaseFirestore.instance.collection('dishes');
    DocumentSnapshot snapshot =
    await collection.doc(order.dishId).get();
    String dishName = snapshot.get('dishName');

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HcDueOrderScreen(
              dishName: dishName, homeCookName: homeCookName, dishOrder: order,)));
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
          leading: ClipOval(
            child: SizedBox.fromSize(
                size: Size.fromRadius(30), // Image radius
                child: returnImage(context, order.dishId!)),
          ),
          title: const Text(
            "Customer Order",
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
            navigateToHcOrderScreen(context, order);
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
                  "Due Orders",
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
