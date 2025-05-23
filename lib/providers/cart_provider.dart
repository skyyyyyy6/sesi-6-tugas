import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/product.dart';

class CartProvider with ChangeNotifier {
  List<Product> _cartItems = [];

  List<Product> get cartItems => _cartItems;

  CartProvider() {
    _loadCartFromPrefs();
  }

  void addToCart(Product product) {
    _cartItems.add(product);
    _saveCartToPrefs();
    notifyListeners();
  }

  void addItem(String id, String title, double price) {
  final product = Product(id: id, title: title, price: price);
  _cartItems.add(product);
  _saveCartToPrefs();
  notifyListeners();
}

  void removeFromCart(Product product) {
    _cartItems.removeWhere((item) => item.id == product.id);
    _saveCartToPrefs();
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    _saveCartToPrefs();
    notifyListeners();
  }

  Future<void> _saveCartToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = _cartItems.map((item) => jsonEncode(item.toMap())).toList();
    prefs.setStringList('cart_items', cartJson);

    print('${_cartItems.length} items saved to cart');
    print('Cart items: $cartJson');
    
  }

  Future<void> _loadCartFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = prefs.getStringList('cart_items') ?? [];
    _cartItems = cartJson.map((item) => Product.fromMap(jsonDecode(item))).toList();
    notifyListeners();
    print('${_cartItems.length} items loaded from cart');
  }
}
