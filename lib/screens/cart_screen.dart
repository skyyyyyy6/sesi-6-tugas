import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.cartItems;

    return Scaffold(
      appBar: AppBar(title: Text("My Cart")),
      body: Column(
        children: [
          Text("Total Items: ${cartItems.length}"),
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (ctx, i) {
                final item = cartItems[i];
                return ListTile(
                  title: Text(item.title),
                  subtitle: Text("\$${item.price.toStringAsFixed(2)}"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}