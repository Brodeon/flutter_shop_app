import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_flutter_app/providers/order.dart';
import 'package:shop_flutter_app/widget/app_drawer.dart';
import 'package:shop_flutter_app/widget/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static final pathName = '/orders';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: FutureBuilder(future: Provider.of<Order>(context, listen: false).fetchAndSetOrders(), builder: (ctx, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(),);
        } else {
          return Consumer<Order>(builder: (ctx, orderData, child) => ListView.builder(itemCount: orderData.orders.length, itemBuilder: (ctx, index) => OrderItemWidget(orderData.orders[index])),);
        }
      }),
      drawer: AppDrawer(),
    );
  }
}
