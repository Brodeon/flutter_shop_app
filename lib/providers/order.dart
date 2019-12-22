import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop_flutter_app/models/http_exception.dart';
import 'package:shop_flutter_app/providers/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({this.id, this.amount, this.products, this.dateTime});

}

class Order with ChangeNotifier {

  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    const url = 'https://flutter-shop-3798e.firebaseio.com/orders.json';
    try {
      var res = await http.get(url);
      if (res.statusCode >= 400) throw HttpException;
      final List<OrderItem> loadedOrders = [];
      final extractedData = json.decode(res.body) as Map<String, dynamic>;
      extractedData.forEach((orderId, orderData) {
        loadedOrders.add(OrderItem(id: orderId, amount: orderData['amount'], dateTime: DateTime.parse(orderData['dateTime']), products: (orderData['products'] as List<dynamic>).map(((cartItem) {
          return CartItem(id: cartItem['id'], price: cartItem['price'], title: cartItem['title'], quantity: cartItem['quantity']);
        })).toList()));
      });
      _orders = loadedOrders;
      notifyListeners();
    } catch(error) {
      throw error;
    }
  }

  Future<void> addOrder(List<CartItem> cartItems, double total) async {
    const url = 'https://flutter-shop-3798e.firebaseio.com/orders.json';
    var timestamp = DateTime.now();
    try {
      var response = await http.post(url, body: json.encode({
        'amount': total,
        'dateTime': timestamp.toIso8601String(),
        'products': cartItems.map((product) => {
          'id': product.id,
          'title': product.title,
          'quantity': product.quantity,
          'price': product.price,
        }).toList()
      }),);
      if (response.statusCode >= 400) throw HttpException;
      OrderItem orderItem = OrderItem(id: json.decode(response.body)['name'], products: cartItems, amount: total, dateTime: timestamp);
      _orders.insert(0, orderItem);
      notifyListeners();
    } catch(error) {
      throw error;
    }
  }

}