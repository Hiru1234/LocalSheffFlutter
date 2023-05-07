import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local_sheff/classes/customDish.dart';

class CusCustomDishScreen extends StatefulWidget {
  final CustomDish customDish;

  const CusCustomDishScreen({Key? key, required this.customDish}) : super(key: key);

  @override
  State<CusCustomDishScreen> createState() => _CusCustomDishScreenState();
}

class _CusCustomDishScreenState extends State<CusCustomDishScreen> {
  String returnOrderState(String orderState) {
    String state = "";
    switch (orderState) {
      case "CustomDishState.created":
        {
          state = "You Created this Dish";
        }
        break;
      case "CustomDishState.accepted":
        {
          state = "This dish was Accepted";
        }
        break;
      case "CustomDishState.prepared":
        {
          state = "This dish was Prepared";
        }
        break;
      case "CustomDishState.completed":
        {
          state = "This order was Completed";
        }
        break;
    }
    return state;
  }

  @override
  Widget build(BuildContext context) {
    final customDish = widget.customDish;
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
                      customDish.homeCookId!,
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
                  "Your instructions",
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
            ]),
          )),
    );
  }
}
