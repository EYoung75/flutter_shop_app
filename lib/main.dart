import "package:flutter/material.dart";
import 'package:provider/provider.dart';

import "./screens/productDetailScreen.dart";
import "./providers/productsProvider.dart";
import './providers/cart.dart';
import "./screens/cartScreen.dart";
import "./providers/orders.dart";
import "./screens/ordersScreen.dart";
import "./screens/userProducts.dart";
import "./screens/editProductScreen.dart";
import "./screens/auth-screen.dart";
import "./providers/auth.dart";

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: ProductsProvider(),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProvider.value(
          value: Orders()
        ),
        ChangeNotifierProvider.value(
          value: Auth()
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "MyShop",
        theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: "Lato"),
        home: AuthScreen(),
        routes: {
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrdersScreen.routeName: (ctx) => OrdersScreen(),
          UserProductScreen.routeName: (ctx) => UserProductScreen(),
          EditProductScreen.routeName: (ctx) => EditProductScreen()
        },
      ),
    );
  }
}
