import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../classes/customDish.dart';
import '../../reusable_widgets/reusable_widget.dart';
import 'hc_home_screen.dart';

class HCustomDishScreen extends StatefulWidget {
  final CustomDish customDish;
  final String customerName;

  const HCustomDishScreen({Key? key, required this.customDish, required this.customerName}) : super(key: key);

  @override
  State<HCustomDishScreen> createState() => _HCustomDishScreenState();
}

class _HCustomDishScreenState extends State<HCustomDishScreen> {
  String returnOrderState(String orderState) {
    String state = "";
    switch (orderState) {
      case "CustomDishState.created":
        {
          state = "Order was Created";
        }
        break;
      case "CustomDishState.accepted":
        {
          state = "Order was Accepted";
        }
        break;
      case "CustomDishState.prepared":
        {
          state = "Order was Prepared";
        }
        break;
      case "CustomDishState.completed":
        {
          state = "Order was Completed";
        }
        break;
    }
    return state;
  }

  @override
  Widget build(BuildContext context) {
    final customDish = widget.customDish;
    final customerName = widget.customerName;
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
                  customDish.dishName!,
                  style: const TextStyle(
                      fontSize: 20,
                      fontFamily: 'SFProDisplay',
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: Text(
                      returnOrderState(customDish.dishState!),
                      style: const TextStyle(
                          fontSize: 18,
                          fontFamily: 'SFProDisplay',
                          color: Colors.green),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: Text(
                      " on ${customDish.date}",
                      style: const TextStyle(
                          fontSize: 18,
                          fontFamily: 'SFProDisplay',
                          color: Colors.black),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
              if(customDish.homeCookId!.isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: Text(
                        "Customer Name",
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'SFProDisplay',
                            color: Colors.black),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: Text(
                        customerName,
                        style: const TextStyle(
                            fontSize: 20,
                            fontFamily: 'SFProDisplay',
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Text(
                  "Customer instructions",
                  style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'SFProDisplay',
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  textAlign: TextAlign.left,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Text(
                  customDish.instructions!,
                  style: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'SFProDisplay',
                      color: Colors.black),
                  textAlign: TextAlign.left,
                ),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
                  child: Text(
                    "Customer correspondence : ",
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'SFProDisplay',
                        color: Colors.black),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 5, 20, 20),
                  child: Text(
                    customDish.email!,
                    style: const TextStyle(
                        fontSize: 18,
                        fontFamily: 'SFProDisplay',
                        fontStyle: FontStyle.italic,
                        color: Colors.black),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              if(customDish.dishState=="CustomDishState.created")
                reusableButton(context, "Accept Order", () async {
                  DateTime now = DateTime.now();
                  String formattedDate = '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';

                  CollectionReference ordersRef = FirebaseFirestore.instance.collection('customDishes');
                  print("Dish Id${customDish.customDishId}");
                  DocumentReference orderRef = ordersRef.doc(customDish.customDishId);

                  final User? user = FirebaseAuth.instance.currentUser;
                  final userID = user?.uid;

                  await orderRef.update({
                    'homeCookId': userID,
                    'dishState': CustomDishState.accepted.toString(),
                    'date': formattedDate
                  }).then((value) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HCHomeScreen()));
                  });
                }, MediaQuery.of(context).size.width, 50),
              if(customDish.dishState=="CustomDishState.accepted")
                reusableButton(context, "Prepare Order", () async {
                  DateTime now = DateTime.now();
                  String formattedDate = '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';

                  CollectionReference ordersRef = FirebaseFirestore.instance.collection('customDishes');
                  DocumentReference orderRef = ordersRef.doc(customDish.customDishId);

                  await orderRef.update({
                    'dishState': CustomDishState.prepared.toString(),
                    'date': formattedDate
                  }).then((value) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HCHomeScreen()));
                  });
                }, MediaQuery.of(context).size.width, 50),
              if(customDish.dishState=="CustomDishState.prepared")
                reusableButton(context, "Complete Order", () async {
                  DateTime now = DateTime.now();
                  String formattedDate = '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';

                  CollectionReference ordersRef = FirebaseFirestore.instance.collection('customDishes');
                  DocumentReference orderRef = ordersRef.doc(customDish.customDishId);

                  await orderRef.update({
                    'dishState': CustomDishState.completed.toString(),
                    'date': formattedDate
                  }).then((value) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HCHomeScreen()));
                  });
                }, MediaQuery.of(context).size.width, 50),
            ]),
          )),
    );
  }
}
