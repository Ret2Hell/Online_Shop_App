import 'package:flutter/material.dart';
import 'package:online_shop/src/models/cart_item.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> cart = [];

  void addProduct(CartItem cartItem) {
    cart.add(cartItem);
    notifyListeners();
  }

  void removeProduct(String id) {
    cart.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  void increaseQuantity(String id) {
    final index = cart.indexWhere((element) => element.id == id);
    cart[index].orderQuantity++;
    notifyListeners();
  }
}
