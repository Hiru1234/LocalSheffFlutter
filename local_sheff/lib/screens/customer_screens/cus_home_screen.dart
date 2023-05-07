import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:local_sheff/reusable_widgets/reusable_widget.dart';
import 'package:local_sheff/screens/customer_screens/cus_account_screen.dart';
import 'package:local_sheff/screens/customer_screens/cus_browse_screen.dart';
import 'package:local_sheff/screens/customer_screens/cus_custom_dishes_screen.dart';
import 'package:local_sheff/screens/customer_screens/cus_orders_screen.dart';
import 'package:local_sheff/screens/start_screen.dart';

import 'cus_create_custom_dish_screen.dart';

class CusHomeScreen extends StatefulWidget {
  const CusHomeScreen({super.key});

  @override
  State<CusHomeScreen> createState() => _CusHomeScreenState();
}

class _CusHomeScreenState extends State<CusHomeScreen> {
  int _selectedIndex = 0;

  void _navigateBottomBar(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    CusBrowseScreen(),
    CusOrdersScreen(),
    CusCreateCustomDishScreen(),
    CusCustomDishesScreen(),
    CusAccountScreen()
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
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_basket),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_box_outlined),
              label: 'Custom Dish'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.list_alt),
              label: 'My Dishes'
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
