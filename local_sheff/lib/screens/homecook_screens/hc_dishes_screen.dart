import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HcDishesScreen extends StatefulWidget {
  const HcDishesScreen({Key? key}) : super(key: key);

  @override
  State<HcDishesScreen> createState() => _HcDishesScreenState();
}

class _HcDishesScreenState extends State<HcDishesScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text("My dishes"),
    );
  }
}
