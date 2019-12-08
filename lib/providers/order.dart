import 'package:flutter/foundation.dart';
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

  addOrder(List<CartItem> cartItems, double total) {
    var date = DateTime.now();
    OrderItem orderItem = OrderItem(id: date.toString(), products: cartItems, amount: total, dateTime: date);
    _orders.insert(0, orderItem);
    notifyListeners();
  }

}