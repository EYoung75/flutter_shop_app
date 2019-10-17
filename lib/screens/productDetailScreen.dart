import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../providers/productsProvider.dart";

class ProductDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;

    final loadedProduct = Provider.of<ProductsProvider>(
      context,
      listen: false,
    ).findById(productId);

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: Container(),
    );
  }
}
