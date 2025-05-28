import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';  // <-- Add this
import 'package:provider/provider.dart';
import './providers/cart_provider.dart';
import './providers/product_provider.dart';
import './screens/cart_screen.dart';
import './screens/product_list_screen.dart';
import './screens/auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProductProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Marketplace',
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            // User logged in
            final uid = snapshot.data!.uid;
            final cartProvider = Provider.of<CartProvider>(context, listen: false);
            cartProvider.loadCartFromFirestore(uid);
            return const ProductListScreen();  // <-- Show main shopping UI here
          }
          // User NOT logged in
          return const AuthScreen();
        },
      ),
      routes: {
        '/cart': (context) => const CartScreen(),
        // add other routes here if needed
      },
    );
  }
}
