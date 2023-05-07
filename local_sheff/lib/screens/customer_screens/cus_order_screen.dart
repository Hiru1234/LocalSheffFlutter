import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local_sheff/classes/dishOrder.dart';

import '../../classes/dish.dart';

class CusOrderScreen extends StatefulWidget {
  final String dishName;
  final String homeCookName;
  final DishOrder dishOrder;

  const CusOrderScreen({Key? key, required this.dishName, required this.homeCookName, required this.dishOrder}) : super(key: key);

  @override
  State<CusOrderScreen> createState() => _CusOrderScreenState();
}

class _CusOrderScreenState extends State<CusOrderScreen> {
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
    final homeCookName = widget.homeCookName;
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
                  "Your Order Receipt",
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
              )
            ]),
          )),
    );
  }
}
