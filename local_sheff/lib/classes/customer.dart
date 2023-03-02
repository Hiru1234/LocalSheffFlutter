class Customer {
  String uID = "";
  String customerName = "";
  String email = "";

  String get get_uID {
    return uID;
  }

  void set set_uID(String uID){
    this.uID = uID;
  }

  String get get_customerName {
    return customerName;
  }

  void set set_customerName(String customerName){
    this.customerName = customerName;
  }

  String get get_email {
    return email;
  }

  void set set_email(String email){
    this.email = email;
  }

  Customer(this.uID, this.customerName, this.email);

}