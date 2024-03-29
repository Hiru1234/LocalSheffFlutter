class CustomDish{
  String? customerId;
  String? date;
  String? dishName;
  String? dishState;
  String? email;
  String? homeCookId;
  String? instructions;
  String? customDishId;

  CustomDish({required this.customerId, required this.date, required this.dishName, required this.dishState, required this.homeCookId, required this.email, required this.instructions, required this.customDishId});

  static CustomDish fromJson(Map<String, dynamic> json) {
    return CustomDish(
        customerId: json["customerId"],
        date: json["date"],
        dishName: json["dishName"],
        dishState: json["dishState"],
        homeCookId: json["homeCookId"],
        email: json["email"],
        instructions: json["instructions"],
        customDishId: json["customDishId"]
    );
  }
}