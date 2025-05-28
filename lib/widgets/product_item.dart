import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/product.dart';
import '../providers/cart_provider.dart';

class ProductItem extends StatelessWidget {
  final Product product;
  const ProductItem({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(product.title),
      trailing: IconButton(
        icon: const Icon(Icons.add_shopping_cart),
        onPressed: () async {
          final user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            await Provider.of<CartProvider>(context, listen: false).addToCart(product, user.uid);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Added to cart')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please login to add items to cart')),
            );
          }
        },
      ),
    );
  }
}
