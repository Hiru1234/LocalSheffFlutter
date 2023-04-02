import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:local_sheff/reusable_widgets/reusable_widget.dart';
import 'package:local_sheff/screens/customer_screens/cus_browse_screen.dart';
import 'package:local_sheff/screens/customer_screens/cus_home_screen.dart';
import 'package:local_sheff/screens/start_screen.dart';

class CusAccountScreen extends StatefulWidget {
  const CusAccountScreen({super.key});

  @override
  State<CusAccountScreen> createState() => _CusAccountScreenState();
}

class _CusAccountScreenState extends State<CusAccountScreen> {
  TextEditingController _userNameTextController =
      TextEditingController(text: StartScreen.nameOfCurrentUser);
  bool isButtonEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(color: Colors.white),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.2, 20, 0),
            child: Column(children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  color: Colors.white,
                  child: const Text(
                    "Your Details",
                    style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'SFProDisplay',
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  color: Colors.white,
                  child: const Text(
                    "User Name",
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'SFProDisplay',
                        color: Colors.black54),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    color: Colors.white,
                    child: TextField(
                      controller: _userNameTextController,
                      obscureText: false,
                      enableSuggestions: false,
                      autocorrect: false,
                      cursorColor: Colors.black,
                      style: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'SFProDisplay',
                          fontSize: 18),
                      decoration: InputDecoration(
                          labelText: StartScreen.nameOfCurrentUser,
                          labelStyle: const TextStyle(
                            color: Colors.black,
                            fontFamily: 'SFProDisplay',
                            fontSize: 18,
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none),
                      keyboardType: TextInputType.name,
                      onChanged: (val) {
                        isEmpty();
                      },
                    )),
              ),
              const Divider(
                height: 20,
                thickness: 1,
                color: Colors.black,
              ),
              ListView.builder(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                itemCount: 1,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return confirmAction(
                                    "Are you sure you want to sign out?",
                                    "Yes",
                                    () {
                                      FirebaseAuth.instance
                                          .signOut()
                                          .then((value) {
                                        print("Signed Out");
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    StartScreen()));
                                      });
                                    },
                                    "No",
                                    () {
                                      Navigator.of(context).pop();
                                    });
                              });
                        },
                        child: const Align(
                          alignment: Alignment.centerLeft,
                          child: Card(
                            child: ListTile(
                              trailing: Icon(Icons.arrow_forward_ios),
                              title: Text(
                                "Sign Out",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SFProDisplay',
                                    fontSize: 18),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return confirmAction(
                                    "Are you sure you want to delete your account? All of your data will be lost",
                                    "Yes",
                                    () {
                                      User? user = FirebaseAuth.instance.currentUser;
                                      String? userID = user?.uid;
                                      print(userID);
                                      user?.delete().then((value) {
                                        DatabaseReference reference = FirebaseDatabase.instance.ref();
                                        print(userID);
                                        reference.child("Users").child(userID!).remove().then((value) {
                                          print("Deleted Account");
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      StartScreen()));
                                        }).catchError((err){
                                          print(err.toString());
                                        });
                                      }).catchError((onError){
                                        print(onError.toString());
                                      });
                                    },
                                    "No",
                                    () {
                                      Navigator.of(context).pop();
                                    });
                              });
                        },
                        child: const Align(
                          alignment: Alignment.centerLeft,
                          child: Card(
                            child: ListTile(
                              trailing: Icon(Icons.arrow_forward_ios),
                              title: Text(
                                "Delete Account",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontFamily: 'SFProDisplay',
                                    fontSize: 18),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                },
              ),
              if (isButtonEnabled)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    reusableButton(context, 'Discard Changes', () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CusHomeScreen()));
                    }, 170, 50),
                    const SizedBox(
                      width: 10,
                    ),
                    reusableButton(context, 'Save Changes', () async {
                      try {
                        final User? user = FirebaseAuth.instance.currentUser;
                        final userID = user?.uid;
                        DatabaseReference reference =
                            FirebaseDatabase.instance.ref("Users/$userID");
                        await reference
                            .update({"userName": _userNameTextController.text});
                        StartScreen.nameOfCurrentUser =
                            _userNameTextController.text;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CusHomeScreen()));
                      } catch (error) {
                        print(error.toString());
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Error",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'SFProDisplay')),
                                content: const Text(
                                    "Unable to update user details",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'SFProDisplay')),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: standardGreyColor,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                      ),
                                      child: const Text("Ok",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'SFProDisplay')))
                                ],
                              );
                            });
                      }
                    }, 170, 50),
                  ],
                ),
            ]),
          ),
        ),
      ),
    );
  }

  bool isEmpty() {
    setState(() {
      if (_userNameTextController.text != StartScreen.nameOfCurrentUser) {
        isButtonEnabled = true;
      }
    });
    return isButtonEnabled;
  }
}
