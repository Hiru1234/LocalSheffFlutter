import 'package:firebase_database/firebase_database.dart';

class Dish{
  String? dishName;
  String? description;
  List<dynamic>? ingredients;
  String? imageReference;
  String? homeCookReference;
  String? price;

  Dish({required this.dishName, required this.description, required this.ingredients, required this.imageReference, required this.homeCookReference, required this.price});

  static Dish fromJson(Map<String, dynamic> json) {
    return Dish(
        dishName: json["dishName"],
        description: json["description"],
        ingredients: json["ingredients"],
        imageReference: json["imageReference"],
        homeCookReference: json["homeCookReference"],
        price: json["price"]
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
        price: value["price"]
    );
  }

}