class DishOrder{
  String? customerId;
  String? customizationNotes;
  String? deliveryCharge;
  String? dishId;
  String? homeCookId;
  String? orderDate;
  String? orderState;
  String? orderType;
  String? quantity;
  String? subTotal;
  String? totalPrice;
  String? orderId;

  DishOrder({required this.customerId, required this.customizationNotes, required this.deliveryCharge, required this.dishId, required this.homeCookId, required this.orderDate, required this.orderState, required this.orderType, required this.quantity, required this.subTotal, required this.totalPrice, required this.orderId});

  static DishOrder fromJson(Map<String, dynamic> json) {
    return DishOrder(
        customerId: json["customerId"],
        customizationNotes: json["customizationNotes"],
        deliveryCharge: json["deliveryCharge"],
        dishId: json["dishId"],
        homeCookId: json["homeCookId"],
        orderDate: json["orderDate"],
        orderState: json["orderState"],
        orderType: json["orderType"],
        quantity: json["quantity"],
        subTotal: json["subTotal"],
        totalPrice: json["totalPrice"],
        orderId: json["orderId"]
    );
  }

}