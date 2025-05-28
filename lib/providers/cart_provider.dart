import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/product.dart';

class CartProvider with ChangeNotifier {
  List<Product> _cartItems = [];

  List<Product> get cartItems => _cartItems;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CartProvider();

  Future<void> loadCartFromFirestore(String uid) async {
    final doc = await _firestore.collection('carts').doc(uid).get();
    if (doc.exists) {
      final data = doc.data();
      final List<dynamic> items = data?['items'] ?? [];
      _cartItems = items.map((item) => Product.fromMap(Map<String, dynamic>.from(item))).toList();
    } else {
      _cartItems = [];
    }
    notifyListeners();
  }

  Future<void> saveCartToFirestore(String uid) async {
    final itemsList = _cartItems.map((item) => item.toMap()).toList();
    await _firestore.collection('carts').doc(uid).set({'items': itemsList});
  }

  Future<void> addToCart(Product product, String uid) async {
    _cartItems.add(product);
    notifyListeners();
    await saveCartToFirestore(uid);
  }

  Future<void> removeFromCart(Product product, String uid) async {
    _cartItems.removeWhere((item) => item.id == product.id);
    notifyListeners();
    await saveCartToFirestore(uid);
  }

  Future<void> clearCart(String uid) async {
    _cartItems.clear();
    notifyListeners();
    await _firestore.collection('carts').doc(uid).delete();
  }
}
