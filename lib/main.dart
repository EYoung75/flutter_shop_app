import "package:flutter/material.dart";
import 'package:provider/provider.dart';

import "./screens/productsOverViewScreen.dart";
import "./screens/productDetailScreen.dart";
import "./providers/productsProvider.dart";

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (ctx) => ProductsProvider(),
      child: MaterialApp(
        title: "MyShop",
        theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: "Lato"),
        routes: {
          "/": (ctx) => ProductsOverviewScreen(),
          "/product-details": (ctx) => ProductDetailScreen()
        },
      ),
    );
  }
}
