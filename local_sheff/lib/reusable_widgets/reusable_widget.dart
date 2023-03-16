import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

const standardGreyColor = Color(0xff262626);
const standardGreenColor = Color(0xff0CE78A);

Image logoWidget(String imageName) {
  return Image.asset(imageName, fit: BoxFit.fitWidth, width: 200, height: 200);
}

TextField reusableTextField(String text, IconData icon, bool isPasswordType,
    TextEditingController controller) {
  return TextField(
    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: Colors.white,
    style: TextStyle(
      color: Colors.black.withOpacity(0.9),
      fontFamily: 'SFProDisplay',
    ),
    decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: Colors.black,
        ),
        labelText: text,
        labelStyle: TextStyle(
          color: Colors.black.withOpacity(0.9),
          fontFamily: 'SFProDisplay',
        ),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: Colors.black.withOpacity(0.3),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(width: 0, style: BorderStyle.none))),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
  );
}

Container resuableButton(BuildContext context, String buttonText,
    Function onTap, double buttonWidth, double buttonHeight) {
  return Container(
    width: buttonWidth,
    height: buttonHeight,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.white24;
            }
            return standardGreyColor;
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
      child: Text(
        buttonText,
        style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
            fontFamily: 'SFProDisplay'),
      ),
    ),
  );
}

String textValidator(String email, String password) {
  if (email.isEmpty || !email.contains('@') || !email.contains('.')) {
    return 'Invalid Email format';
  }

  if (password.isEmpty) {
    return 'Please enter a password';
  }

  return 'User already exists. Please register with another email.';
}

enum UserType { customer, homecook, deliveryPerson }

AlertDialog confirmAction(
    String message,
    String confirmText,
    Function confirmFunc,
    String denyText,
    Function denyFunc) {
  return AlertDialog(
    content: Text(message,
        style:
            const TextStyle(color: Colors.black, fontFamily: 'SFProDisplay')),
    actions: [
      ElevatedButton(
          onPressed: () {
            confirmFunc();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: standardGreyColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          ),
          child: Text(confirmText,
              style: const TextStyle(
                  color: Colors.white, fontFamily: 'SFProDisplay'))),
      ElevatedButton(
          onPressed: () {
            denyFunc();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: standardGreyColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          ),
          child: Text(denyText,
              style: const TextStyle(
                  color: Colors.white, fontFamily: 'SFProDisplay')))
    ],
  );
}
