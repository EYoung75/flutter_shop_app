import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import 'package:shop_app/models/httpException.dart';
import "dart:convert";

import "./product.dart";
import "../models/httpException.dart";

class ProductsProvider with ChangeNotifier {
  final String authToken;
  final String userId;
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // )
  ];

  ProductsProvider(this.authToken, this.userId, this._items);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((productItem) => productItem.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere(
      (product) => product.id == id,
    );
  }

  Future<void> deleteProduct(String id) async {
    final url =
        "https://shopapp-61088.firebaseio.com/products/$id.json?auth=$authToken";
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];

    _items.removeAt(existingProductIndex);
    notifyListeners();

    final res = await http.delete(url);

    if (res.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException("Unable to delete product");
    }
    existingProduct = null;
  }

  Future<void> fetchProducts([bool filterByUser = false]) async {
    final filterString = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        'https://shopapp-61088.firebaseio.com/products.json?auth=$authToken&$filterString';
        
    try {
      final res = await http.get(url);
      final data = json.decode(res.body) as Map<String, dynamic>;
      if (data == null) {
        return;
      }
      url =  "https://shopapp-61088.firebaseio.com/userFavorites/$userId.json?auth=$authToken";
      final getFavoriteStatus = await http.get(url);
      final favData = json.decode(getFavoriteStatus.body);
      final List<Product> loadedProducts = [];
      data.forEach((prodId, prodData) {
        loadedProducts.add(
          Product(
            id: prodId,
            title: prodData["title"],
            description: prodData["description"],
            price: prodData["price"],
            isFavorite: favData == null ? false : favData[prodId] ?? false,
            imageUrl: prodData["imageUrl"],
          ),
        );
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (err) {
      throw (err);
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        "https://shopapp-61088.firebaseio.com/products.json?auth=$authToken";
    try {
      final res = await http.post(
        url,
        body: json.encode({
          "title": product.title,
          "description": product.description,
          "imageUrl": product.imageUrl,
          "price": product.price,
          "creatorId": userId
        }),
      );
      print(json.decode(res.body));
      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(res.body)["name"],
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final productIndex = _items.indexWhere((prod) => prod.id == id);
    if (productIndex >= 0) {
      final url =
          "https://shopapp-61088.firebaseio.com/products/$id.json?auth=$authToken";
      await http.patch(
        url,
        body: json.encode(
          {
            "title": newProduct.title,
            "description": newProduct.description,
            "imageUrl": newProduct.imageUrl,
            "price": newProduct.price,
          },
        ),
      );
      _items[productIndex] = newProduct;
      notifyListeners();
    } else {
      print("");
    }
  }
}
