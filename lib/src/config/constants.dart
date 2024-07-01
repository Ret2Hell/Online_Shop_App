import 'package:flutter/material.dart';
import 'package:online_shop/src/ui/screens/account_screen.dart';
import 'package:online_shop/src/ui/screens/cart_screen.dart';
import 'package:online_shop/src/ui/screens/home_screen.dart';

const List<String> categories = [
  "All",
  "Clothes",
  "Footwear",
  "Home & Kitchen",
  "Electronics",
];

List<Widget> screens = const [
  HomeScreen(),
  CartScreen(),
  AccountScreen(),
];

const List<Widget> navigationBarIcons = [
  Icon(Icons.home, size: 30),
  Icon(Icons.shopping_cart, size: 30),
  Icon(Icons.account_box, size: 30),
];
