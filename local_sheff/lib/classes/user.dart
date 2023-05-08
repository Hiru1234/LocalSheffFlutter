import 'package:firebase_database/firebase_database.dart';

class AppUser{
  String? userName;
  String? userEmail;
  String? role;
  String? imageReference;
  String? postcode;

  AppUser({required this.userName, required this.userEmail,required this.role,required this.imageReference, required this.postcode});

  factory AppUser.fromSnapshot(DataSnapshot snapshot) {
    Map<String, dynamic> value = Map<String, dynamic>.from(snapshot.value as Map<dynamic, dynamic>);
    return AppUser(
      imageReference: value['image'],
      role: value['role'],
      userEmail: value['userEmail'],
      userName: value['userName'],
      postcode: value['postcode']
    );
  }

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      userName: json['userName'],
      userEmail: json['userEmail'],
      role: json['role'],
      postcode: json['postcode'],
      imageReference: json['image'],
    );
  }
}