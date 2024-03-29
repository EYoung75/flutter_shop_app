import "dart:convert";

import "package:flutter/foundation.dart";
import "package:http/http.dart" as http;

import "./cart.dart";

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;
  final String userId;

  Orders(this.authToken, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchOrders() async {
    final url =
        "https://shopapp-61088.firebaseio.com/orders/$userId.json?auth=$authToken";
    final res = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final data = json.decode(res.body) as Map<String, dynamic>;
    if (data == null) {
      return;
    }
    data.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          id: orderId,
          amount: orderData["amount"],
          dateTime: DateTime.parse(orderData["dateTime"]),
          products: (orderData["products"] as List<dynamic>)
              .map(
                (item) => CartItem(
                  id: item["id"],
                  price: item["price"],
                  quantity: item["quantity"],
                  title: item["title"],
                ),
              )
              .toList(),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url =
        "https://shopapp-61088.firebaseio.com/orders/$userId.json?auth=$authToken";
    final timestamp = DateTime.now();
    final res = await http.post(
      url,
      body: json.encode(
        ({
          "amount": total,
          "dateTime": timestamp.toIso8601String(),
          "products": cartProducts
              .map((prod) => {
                    "id": prod.id,
                    "title": prod.title,
                    "quanitity": prod.quantity,
                    "price": prod.price
                  })
              .toList()
        }),
      ),
    );
    _orders.insert(
      0,
      OrderItem(
          id: json.decode(res.body)["name"],
          amount: total,
          dateTime: timestamp,
          products: cartProducts),
    );
    notifyListeners();
  }
}
