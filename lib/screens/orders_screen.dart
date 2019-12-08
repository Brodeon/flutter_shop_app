import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_flutter_app/providers/order.dart';
import 'package:shop_flutter_app/widget/app_drawer.dart';
import 'package:shop_flutter_app/widget/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static final pathName = '/orders';

  @override
  Widget build(BuildContext context) {
    var orderData = Provider.of<Order>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: ListView.builder(itemCount: orderData.orders.length, itemBuilder: (ctx, index) => OrderItemWidget(orderData.orders[index]),),
      drawer: AppDrawer(),
    );
  }
}
