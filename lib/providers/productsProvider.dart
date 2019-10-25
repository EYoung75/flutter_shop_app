import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import "dart:convert";

import "./product.dart";

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

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

  Future<void> updateProduct(String id, Product newProduct) async {
    final productIndex = _items.indexWhere((prod) => prod.id == id);
    if (productIndex >= 0) {
      final url = "https://shopapp-61088.firebaseio.com/products/$id.json";
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

  void deleteProduct(String id) {
    final url = "https://shopapp-61088.firebaseio.com/products/$id.json";
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];

    http.delete(url).then((res) {
      if(res.statusCode >= 400) {
        throw Exception();
      }
      existingProduct = null;
    }).catchError((_) {
      _items.insert(existingProductIndex, existingProduct);
    });
    _items.removeAt(existingProductIndex);
    notifyListeners();
  }

  Future<void> fetchProducts() async {
    const url = "https://shopapp-61088.firebaseio.com/products.json";
    try {
      final res = await http.get(url);
      final data = json.decode(res.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      data.forEach((prodId, prodData) {
        loadedProducts.add(Product(
            id: prodId,
            title: prodData["title"],
            description: prodData["description"],
            price: prodData["price"],
            imageUrl: prodData["imageUrl"],
            isFavorite: prodData["isFavorite"]));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (err) {
      throw (err);
    }
  }

  Future<void> addProduct(Product product) async {
    const url = "https://shopapp-61088.firebaseio.com/products.json";
    try {
      final res = await http.post(
        url,
        body: json.encode({
          "title": product.title,
          "description": product.description,
          "imageUrl": product.imageUrl,
          "price": product.price,
          "isFavorite": product.isFavorite
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
}
