import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local_sheff/classes/dishOrder.dart';
import 'package:local_sheff/reusable_widgets/reusable_widget.dart';

import 'hc_home_screen.dart';

class HcDueOrderScreen extends StatefulWidget {
  final DishOrder dishOrder;
  final String homeCookName;
  final String dishName;

  const HcDueOrderScreen({Key? key, required this.dishOrder, required this.dishName, required this.homeCookName}) : super(key: key);

  @override
  State<HcDueOrderScreen> createState() => _HcDueOrderScreenState();
}

class _HcDueOrderScreenState extends State<HcDueOrderScreen> {
  String returnOrderState(String orderState) {
    String state = "";
    switch (orderState) {
      case "OrderState.placed":
        {
          state = "Order has been Placed";
        }
        break;
      case "OrderState.accepted":
        {
          state = "Order has been Accepted";
        }
        break;
      case "OrderState.prepared":
        {
          state = "Order has been Prepared";
        }
        break;
      case "OrderState.collectedByDriver":
        {
          state = "Order has been Collected by Driver";
        }
        break;
      case "OrderState.completed":
        {
          state = "Order has been Completed";
        }
        break;
    }
    return state;
  }

  @override
  Widget build(BuildContext context) {
    final dishOrder = widget.dishOrder;
    final homeCookName = widget.homeCookName;
    final dishName = widget.dishName;
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
              const Center(
                child: Text(
                  "Order Details",
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: Text(
                      returnOrderState(dishOrder.orderState!),
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
                      " on ${dishOrder.orderDate}",
                      style: const TextStyle(
                          fontSize: 18,
                          fontFamily: 'SFProDisplay',
                          color: Colors.black),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Text(
                      "Dish Name",
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
                      dishName,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Text(
                      "Home Cook Name",
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
                      homeCookName,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Text(
                      "Ordered Quantity",
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
                      dishOrder.quantity!,
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
              if(dishOrder.customizationNotes!.isNotEmpty)
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Text(
                    "Customer Instructions:\n"
                        "${dishOrder.customizationNotes}",
                    style: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'SFProDisplay',
                        color: Colors.black),
                    textAlign: TextAlign.left,
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Text(
                      "Order Type",
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
                      dishOrder.orderType == "OrderType.delivery"? "Delivery":"Collection",
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Text(
                      "Sub Total",
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
                      "£${dishOrder.subTotal}",
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
              if(dishOrder.orderType == "OrderType.delivery")
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: Text(
                        "Delivery Charge",
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
                        "£${dishOrder.deliveryCharge}",
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Text(
                      "Total Price",
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
                      "£${dishOrder.totalPrice}",
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
              if(dishOrder.orderState=="OrderState.placed")
                reusableButton(context, "Accept Order", () async {
                  DateTime now = DateTime.now();
                  String formattedDate = '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';

                  CollectionReference ordersRef = FirebaseFirestore.instance.collection('orders');
                  DocumentReference orderRef = ordersRef.doc(dishOrder.orderId);

                  await orderRef.update({
                    'orderState': OrderState.accepted.toString(),
                    'orderDate': formattedDate
                  }).then((value) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HCHomeScreen()));
                  });
                }, MediaQuery.of(context).size.width, 50)
              else if(dishOrder.orderState=="OrderState.accepted")
                reusableButton(context, "Prepare Order", () async {
                  DateTime now = DateTime.now();
                  String formattedDate = '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';

                  CollectionReference ordersRef = FirebaseFirestore.instance.collection('orders');
                  DocumentReference orderRef = ordersRef.doc(dishOrder.orderId);

                  await orderRef.update({
                    'orderState': OrderState.prepared.toString(),
                    'orderDate': formattedDate
                  }).then((value) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HCHomeScreen()));
                  });
                }, MediaQuery.of(context).size.width, 50)
              else if(dishOrder.orderState=="OrderState.prepared" && dishOrder.orderType == "OrderType.collection")
                  reusableButton(context,  "Complete Order", () async {
                    DateTime now = DateTime.now();
                    String formattedDate = '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';

                    CollectionReference ordersRef = FirebaseFirestore.instance.collection('orders');
                    DocumentReference orderRef = ordersRef.doc(dishOrder.orderId);
                    //String newState = dishOrder.orderType == "OrderType.delivery"? OrderState.collectedByDriver.toString():OrderState.completed.toString();

                    await orderRef.update({
                      'orderState': OrderState.completed.toString(),
                      'orderDate': formattedDate
                    }).then((value) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HCHomeScreen()));
                    });
                  }, MediaQuery.of(context).size.width, 50)
            ]),
          )),
    );
  }
}
