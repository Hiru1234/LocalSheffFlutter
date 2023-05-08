import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:local_sheff/classes/dish.dart';
import 'package:local_sheff/reusable_widgets/reusable_widget.dart';
import 'package:local_sheff/screens/customer_screens/cus_home_screen.dart';
import 'package:local_sheff/screens/customer_screens/cus_rate_hc_screen.dart';

import '../../classes/nutritionalInformation.dart';
import '../../classes/user.dart';
import '../homecook_screens/hc_home_screen.dart';

class CusDishScreen extends StatefulWidget {
  final Dish dish;
  final AppUser appUser;
  final NutritionalInformation nutritionalInfo;

  const CusDishScreen({Key? key, required this.dish, required this.appUser, required this.nutritionalInfo}) : super(key: key);

  @override
  State<CusDishScreen> createState() => _CusDishScreenState();
}

class _CusDishScreenState extends State<CusDishScreen> {
  TextEditingController _ingredientTextController = TextEditingController();
  TextEditingController _customizationTextController = TextEditingController();
  List<dynamic> allIngredients = List<dynamic>.empty();

  String searchResult = "";
  String homeCookName = "";
  int quantity = 0;
  OrderType orderType = OrderType.collection;
  double subTotal = 0.0;
  double totalPrice = 0.0;
  double deliveryCharge = 0.0;

  Future<Uint8List?> loadImage(String url, bool isDishImage) async {
    String databaseName = "";
    if(isDishImage){
      databaseName = "dishes";
    }else{
      databaseName = "users";
    }
    final Reference ref =
    FirebaseStorage.instance.ref().child(databaseName).child(url);
    const int maxSize = 10 * 1024 * 1024;
    final Uint8List? imageData = await ref.getData(maxSize);
    return imageData;
  }

  Widget returnImage(BuildContext context, String imageUrl, bool isDishImage) {
    return FutureBuilder<Uint8List?>(
      future: loadImage(imageUrl, isDishImage),
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

  void searchIngredients(String query, List<dynamic>? ingredients) {
    final suggestions = ingredients?.where((ingredient) {
      final ingredientName = ingredient.toLowerCase();
      final input = query.toLowerCase();

      return ingredientName.contains(input);
    }).toList();

    setState(() {
      allIngredients = suggestions!;
      if (allIngredients.isEmpty) {
        searchResult = "No such ingredient found";
      } else {
        searchResult = "";
      }
    });
  }

  @override
  void initState() {
    super.initState();
    allIngredients = widget.dish.ingredients!;
  }

  void calculateSubTotal(){
    subTotal = double.parse(widget.dish.price!)*quantity;
  }

  void calculateDeliveryCharge(){
    if(subTotal * 10/100 <= 2.99){
      deliveryCharge = subTotal * 10/100;
    }
    else{
      deliveryCharge = 2.99;
    }
    print("Delivery ${deliveryCharge}");
  }

  void calculateTotalPrice(){
    totalPrice = subTotal + deliveryCharge;
  }

  void _increment() {
    setState(() {
      quantity++;
      calculateSubTotal();
      calculateTotalPrice();
      if(orderType == OrderType.delivery){
        calculateDeliveryCharge();
      }
    });
  }

  void _decrement() {
    setState(() {
      if(quantity == 1){
        subTotal = 0.0;
        deliveryCharge = 0.0;
        totalPrice = 0.0;
      }
      if (quantity > 0) {
        quantity--;
      }
      calculateSubTotal();
      calculateTotalPrice();
      if(orderType == OrderType.delivery){
        calculateDeliveryCharge();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final dish = widget.dish;
    final appUser = widget.appUser;
    final nutritionalInfo = widget.nutritionalInfo;
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
              ListTile(
                leading: ClipOval(
                  child: SizedBox.fromSize(
                      size: Size.fromRadius(30), // Image radius
                      child: returnImage(context, appUser.imageReference!, false)),
                ),
                title: Text(
                  appUser.userName!,
                  style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'SFProDisplay',
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                trailing: const Icon(Icons.verified, color: Colors.green,),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CusRateHCScreen(appUser: appUser,homeCookReference: dish.homeCookReference!,)),
                  );
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  dish.dishName!.toString(),
                  style: const TextStyle(
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
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: MediaQuery.of(context).size.width * 0.6,
                  child: returnImage(context, dish.imageReference!, true),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "Price",
                      style: TextStyle(
                          fontSize: 21,
                          fontFamily: 'SFProDisplay',
                          color: Colors.black),
                      textAlign: TextAlign.left,
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "£${dish.price}",
                      style: const TextStyle(
                          fontSize: 21,
                          fontFamily: 'SFProDisplay',
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                    child: Text(
                      dish.description!.toString(),
                      style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'SFProDisplay',
                          color: Colors.black),
                      textAlign: TextAlign.left,
                    ),
                  )),
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Text(
                      "Ingredients",
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'SFProDisplay',
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      textAlign: TextAlign.left,
                    ),
                  )),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: TextField(
                      controller: _ingredientTextController,
                      onChanged: (String value) {
                        searchIngredients(
                            _ingredientTextController.text, dish.ingredients);
                      },
                      decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.black,
                          ),
                          labelText: "Search Ingredients",
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
              if (allIngredients.isNotEmpty)
                Align(
                  alignment: Alignment.centerLeft,
                  child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      itemExtent: 30,
                      shrinkWrap: true,
                      itemCount: allIngredients.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 4.0),
                          dense: true,
                          title: Text(
                            allIngredients[index],
                            style: const TextStyle(
                                fontSize: 16,
                                fontFamily: 'SFProDisplay',
                                color: Colors.black),
                            textAlign: TextAlign.left,
                          ),
                        );
                      }),
                )
              else
                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: Text(
                        searchResult,
                        style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'SFProDisplay',
                            color: Colors.black),
                        textAlign: TextAlign.left,
                      ),
                    )),
              const SizedBox(
                height: 10,
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Text(
                        "Nutritional data :\n\n"
                            "   CHOCDF : ${nutritionalInfo.chocdf}\n"
                            "   ENERC_KCAL : ${nutritionalInfo.enercKcal}\n"
                            "   FAT : ${nutritionalInfo.fat}\n"
                            "   FIBTG : ${nutritionalInfo.fibtg}\n"
                            "   PROCNT : ${nutritionalInfo.procnt}\n",
                        style: const TextStyle(
                            color: Colors.black,
                            fontFamily: 'SFProDisplay',
                            fontSize: 17)),
                  )
              ),
              TextFormField(
                controller: TextEditingController(text: '$quantity'),
                keyboardType: TextInputType.number,
                onChanged: (newValue) {
                  setState(() {
                    quantity = int.parse(newValue);
                  });
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  labelText: 'Quantity',
                  labelStyle: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'SFProDisplay',
                      color: Colors.black),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: _increment,
                      ),
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: _decrement,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: TextField(
                        maxLines: 5,
                        controller: _customizationTextController,
                        obscureText: false,
                        enableSuggestions: false,
                        autocorrect: false,
                        cursorColor: Colors.black,
                        style: const TextStyle(
                            color: Colors.black,
                            fontFamily: 'SFProDisplay',
                            fontSize: 18),
                        decoration: InputDecoration(
                          labelText: "Dish customization notes",
                          labelStyle: const TextStyle(
                            color: Colors.black,
                            fontFamily: 'SFProDisplay',
                            fontSize: 22,
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  width: 2, style: BorderStyle.solid)),
                        ),
                        keyboardType: TextInputType.name,
                      ))),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ChoiceChip(
                    label: const Text('I want to collect',
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'SFProDisplay',
                            color: Colors.black)),
                    selected: (orderType == OrderType.collection),
                    selectedColor: Colors.grey,
                    onSelected: (bool selected) {
                      orderType = OrderType.collection;
                      setState(() {
                        deliveryCharge = 0.0;
                        calculateTotalPrice();
                      });
                      // Handle choice 1 selection
                    },
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  ChoiceChip(
                    label: const Text('I want delivery',
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'SFProDisplay',
                            color: Colors.black)),
                    selected: (orderType == OrderType.delivery),
                    selectedColor: Colors.grey,
                    onSelected: (bool selected) {
                      orderType = OrderType.delivery;
                      setState(() {
                        calculateDeliveryCharge();
                        calculateTotalPrice();
                      });
                      },
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              if(subTotal != 0.0)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "Sub Total",
                        style: TextStyle(
                            fontSize: 19,
                            fontFamily: 'SFProDisplay',
                            color: Colors.black),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 2.5),
                      child: Text(
                        "£${subTotal.toStringAsFixed(2)}",
                        style: const TextStyle(
                            fontSize: 19,
                            fontFamily: 'SFProDisplay',
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              if(orderType == OrderType.delivery && deliveryCharge != 0.0)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(20, 2.5, 20, 2.5),
                      child: Text(
                        "Delivery Charge",
                        style: TextStyle(
                            fontSize: 17,
                            fontFamily: 'SFProDisplay',
                            color: Colors.black),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 2.5, 20, 10),
                      child: Text(
                        "£${deliveryCharge.toStringAsFixed(2)}",
                        style: const TextStyle(
                            fontSize: 17,
                            fontFamily: 'SFProDisplay',
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              if(totalPrice != 0.0)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "Total Price",
                        style: TextStyle(
                            fontSize: 21,
                            fontFamily: 'SFProDisplay',
                            color: Colors.black),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "£${totalPrice.toStringAsFixed(2)}",
                        style: const TextStyle(
                            fontSize: 21,
                            fontFamily: 'SFProDisplay',
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              const SizedBox(
                height: 20,
              ),
              reusableButton(context, "Place Order", () async {
                if (quantity == 0) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                        'Quantity cannot be 0',
                        style: TextStyle(
                          fontFamily: 'SFProDisplay',
                          fontSize: 17,
                        ),
                      )));
                  return;
                }
                final User? user = FirebaseAuth.instance.currentUser;
                final userID = user?.uid;

                FirebaseFirestore db = FirebaseFirestore.instance;

                String uniqueId = "DS${DateTime.now().millisecondsSinceEpoch}";

                CollectionReference users = FirebaseFirestore.instance.collection('dishes');

                QuerySnapshot querySnapshot = await users.where('imageReference', isEqualTo: dish.imageReference).get();
                String documentId = "";

                querySnapshot.docs.forEach((documentSnapshot) {
                  documentId = documentSnapshot.id;
                });

                DateTime now = DateTime.now();
                String formattedDate = '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';

                //Create a Map of data
                Map<String, dynamic> dataToSend = {
                  'dishId': documentId,
                  'customerId': userID,
                  'homeCookId': dish.homeCookReference,
                  'quantity': quantity.toString(),
                  'orderType': orderType.toString(),
                  'subTotal': subTotal.toStringAsFixed(2),
                  'deliveryCharge': deliveryCharge.toStringAsFixed(2),
                  'totalPrice' : totalPrice.toStringAsFixed(2),
                  'customizationNotes' : _customizationTextController.text,
                  'orderState': OrderState.placed.toString(),
                  'orderDate': formattedDate,
                  'orderId':uniqueId
                };

                db
                    .collection("orders")
                    .doc(uniqueId)
                    .set(dataToSend)
                    .then((value) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CusHomeScreen()));
                }).catchError((err) {
                  print(err);
                });
              },
                  MediaQuery.of(context).size.width, 50)
            ]),
          )),
    );
  }
}
