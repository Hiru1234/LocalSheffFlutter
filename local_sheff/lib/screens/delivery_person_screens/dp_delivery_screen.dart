import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local_sheff/classes/dishOrder.dart';
import 'package:local_sheff/classes/user.dart';
import 'package:local_sheff/screens/delivery_person_screens/dp_home_screen.dart';

import '../../reusable_widgets/reusable_widget.dart';

class DpDeliveryScreen extends StatefulWidget {
  final DishOrder dishOrder;
  final AppUser homeCook;
  final AppUser customer;
  final String dishName;

  const DpDeliveryScreen(
      {Key? key,
      required this.homeCook,
      required this.customer,
      required this.dishName,
      required this.dishOrder})
      : super(key: key);

  @override
  State<DpDeliveryScreen> createState() => _DpDeliveryScreenState();
}

class _DpDeliveryScreenState extends State<DpDeliveryScreen> {
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
    final dishName = widget.dishName;
    final homeCook = widget.homeCook;
    final customer = widget.customer;
    final dishOrder = widget.dishOrder;
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
                      homeCook.userName!,
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
                      "Home Cook Postcode",
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
                      homeCook.postcode!,
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
                      customer.userName!,
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
                      "Customer Postcode",
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
                      customer.postcode!,
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
              if (dishOrder.orderState == "OrderState.prepared")
                reusableButton(context, "Accept Delivery", () async {
                  DateTime now = DateTime.now();
                  String formattedDate =
                      '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';

                  CollectionReference ordersRef =
                      FirebaseFirestore.instance.collection('orders');
                  DocumentReference orderRef = ordersRef.doc(dishOrder.orderId);
                  //String newState = dishOrder.orderType == "OrderType.delivery"? OrderState.collectedByDriver.toString():OrderState.completed.toString();

                  await orderRef.update({
                    'orderState': OrderState.collectedByDriver.toString(),
                    'orderDate': formattedDate
                  }).then((value) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DpHomeScreen()));
                  });
                }, MediaQuery.of(context).size.width, 50),
              if (dishOrder.orderState == "OrderState.collectedByDriver")
                reusableButton(context, "Complete Delivery", () async {
                  DateTime now = DateTime.now();
                  String formattedDate =
                      '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';

                  CollectionReference ordersRef =
                  FirebaseFirestore.instance.collection('orders');
                  DocumentReference orderRef = ordersRef.doc(dishOrder.orderId);
                  //String newState = dishOrder.orderType == "OrderType.delivery"? OrderState.collectedByDriver.toString():OrderState.completed.toString();

                  await orderRef.update({
                    'orderState': OrderState.completed.toString(),
                    'orderDate': formattedDate
                  }).then((value) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DpHomeScreen()));
                  });
                }, MediaQuery.of(context).size.width, 50)
            ]),
          )),
    );
  }
}
