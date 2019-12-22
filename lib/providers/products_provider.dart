import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_flutter_app/models/http_exception.dart';
import 'package:shop_flutter_app/providers/product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [];

  var _showFavouritesOnly = false;

  List<Product> get products {
    if (_showFavouritesOnly) {
      return [..._items.where((pr) => pr.isFavourite).toList()];
    }
    return [..._items];
  }

  List<Product> get favouriteItems {
    return [...products.where((prod) => prod.isFavourite).toList()];
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

   Future<void> addProduct(Product product) async {
    const url = 'https://flutter-shop-3798e.firebaseio.com/products.json';
    try {
      var response = await http.post(url, body: json.encode(product.toJson));
      final newProduct = Product(title: product.title, description: product.description, price: product.price, imageUrl: product.imageUrl, id: json.decode(response.body)['name']);
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(Product product) async {
    final index = _items.indexWhere((pr) => pr.id == product.id);
    if (index > -1) {
      final url = 'https://flutter-shop-3798e.firebaseio.com/products/${product.id}.json';
      try {
        var res = await http.patch(url, body: json.encode(product.toJson));
        _items[index] = product;
        notifyListeners();
      } catch(error) {
        throw error;
      }
    }
  }

  Future<void> deleteItem(String id) async {
    final url = 'https://flutter-shop-3798e.firebaseio.com/products/$id.json';
    final existingProductIndex = _items.indexWhere((v) => v.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();

    try {
      final res = await http.delete(url);
      existingProduct = null;
    } catch(error) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product');
    }
  }

  Future<void> fetchAndSetProducts() async {
    const url = 'https://flutter-shop-3798e.firebaseio.com/products.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(id: prodId, title: prodData['title'], description: prodData['description'], price: prodData['price'], isFavourite: prodData['isFavourite'], imageUrl: prodData['imageUrl']));
      });
      print(loadedProducts);
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }













}