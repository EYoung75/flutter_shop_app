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
  // final String authToken;

  Product({
    this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
    // @required this.authToken
  });

  Future<void> toggleFavorite(String token, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url =
        "https://shopapp-61088.firebaseio.com/userFavorites/$userId/$id.json?auth=$token";
    try {
      final res = await http.put(
        url,
        body: json.encode(
          isFavorite,
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
