import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../providers/productsProvider.dart";
import "../widgets/userProduct.dart";
import "../widgets/appDrawer.dart";

class UserProductScreen extends StatelessWidget {
  static const routeName = "/userProducts";

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<ProductsProvider>(context).fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Products"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed("/editProduct");
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: products.items.length,
            itemBuilder: (_, i) => Column(
              children: <Widget>[
                UserProduct(
                  products.items[i].id,
                  products.items[i].title,
                  products.items[i].imageUrl,
                ),
                Divider()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
