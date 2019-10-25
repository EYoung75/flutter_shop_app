import "package:flutter/foundation.dart";
import "package:http/http.dart" as http;
import "dart:convert";

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavorite() async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = "https://shopapp-61088.firebaseio.com/products/$id.json";
    try {
      final res = await http.patch(
        url,
        body: json.encode(
          {
            "isFavorite": isFavorite,
          },
        ),
      );
      if (res.statusCode >= 400) {
        isFavorite = oldStatus;
        notifyListeners();
      }
    } catch (err) {
      isFavorite = oldStatus;
      notifyListeners();
    }
  }
}
