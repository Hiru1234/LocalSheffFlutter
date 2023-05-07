import 'package:firebase_database/firebase_database.dart';

class AppUser{
  String? userName;
  String? userEmail;
  String? role;
  String? imageReference;
  String? postcode;

  AppUser({this.userName, this.userEmail, this.role, this.imageReference, required this.postcode});

  factory AppUser.fromSnapshot(DataSnapshot snapshot) {
    Map<String, dynamic> value = Map<String, dynamic>.from(snapshot.value as Map<String, dynamic>);
    return AppUser(
      imageReference: value['image'],
      role: value['role'],
      userEmail: value['userEmail'],
      userName: value['userName'],
      postcode: value['postcode']
    );
  }
}