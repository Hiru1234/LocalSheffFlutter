import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:local_sheff/screens/homecook_screens/hc_account_screen.dart';
import 'package:local_sheff/screens/homecook_screens/hc_add_dish_screen.dart';
import 'package:local_sheff/screens/homecook_screens/hc_custom_dishes_screen.dart';
import 'package:local_sheff/screens/homecook_screens/hc_dishes_screen.dart';
import 'package:local_sheff/screens/homecook_screens/hc_due_orders_screen.dart';
import 'package:local_sheff/screens/start_screen.dart';

import '../../reusable_widgets/reusable_widget.dart';

class HCHomeScreen extends StatefulWidget {
  const HCHomeScreen({super.key});

  @override
  State<HCHomeScreen> createState() => _HCHomeScreenState();
}

class _HCHomeScreenState extends State<HCHomeScreen> {
  int _selectedIndex = 0;

  void _navigateBottomBar(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    HcDishesScreen(),
    HcAddDishScreen(),
    HcDueOrdersScreen(),
    HcCustomDishesScreen(),
    HcAccountScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _navigateBottomBar,
        unselectedItemColor: standardGreyColor,
        selectedItemColor: standardGreenColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.food_bank_outlined),
            label: 'My dishes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: 'Add Dish',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.food_bank_outlined),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Request Dishes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          )
        ],
      ),
    );
  }
}