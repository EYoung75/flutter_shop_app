import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../providers/orders.dart";
import "../widgets/orderItem.dart";
import "../widgets/appDrawer.dart";

class OrdersScreen extends StatelessWidget {
  static const routeName = "/orders";   

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      appBar: AppBar(
        title: Text("Your orders"),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchOrders(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (dataSnapshot.error != null) {
              return Center(
                child: Text("An error occurred"),
              );
            } else {
              return Consumer<Orders>(
                builder: (ctx, orderData, child) => ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (ctx, i) => OrderTile(orderData.orders[i]),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
