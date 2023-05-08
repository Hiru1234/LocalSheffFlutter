import 'package:firebase_database/firebase_database.dart';

class Dish{
  String? dishName;
  String? description;
  List<dynamic>? ingredients;
  String? imageReference;
  String? homeCookReference;
  String? price;
  Map<String, dynamic>? nutritionalInformation;

  Dish({required this.dishName, required this.description, required this.ingredients, required this.imageReference, required this.homeCookReference, required this.price,this.nutritionalInformation});

  static Dish fromJson(Map<String, dynamic> json) {
    return Dish(
        dishName: json["dishName"],
        description: json["description"],
        ingredients: json["ingredients"],
        imageReference: json["imageReference"],
        homeCookReference: json["homeCookReference"],
        price: json["price"],
        nutritionalInformation: json["nutritionalInformation"]
    );
  }

  factory Dish.fromSnapshot(DataSnapshot snapshot) {
    Map<String, dynamic> value = Map<String, dynamic>.from(snapshot.value as Map<dynamic, dynamic>);
    return Dish(
        dishName: value["dishName"],
        description: value["description"],
        ingredients: value["ingredients"],
        imageReference: value["imageReference"],
        homeCookReference: value["homeCookReference"],
        price: value["price"],
        nutritionalInformation: value["nutritionalInformation"]
    );
  }

}