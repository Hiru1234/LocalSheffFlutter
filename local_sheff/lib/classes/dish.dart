class Dish{
  String? dishName;
  String? description;
  List<dynamic>? ingredients;
  String? imageReference;
  String? homeCookReference;

  Dish({required this.dishName, required this.description, required this.ingredients, required this.imageReference, required this.homeCookReference});

  static Dish fromJson(Map<String, dynamic> json) {
    return Dish(
        dishName: json["dishName"],
        description: json["description"],
        ingredients: json["ingredients"],
        imageReference: json["imageReference"],
        homeCookReference: json["homeCookReference"]
    );
  }

}