import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_flutter_app/providers/cart.dart';
import 'package:shop_flutter_app/providers/order.dart';
import 'package:shop_flutter_app/widget/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    void addCartToOrders() {
      Provider.of<Order>(context, listen: false).addOrder(cart.items.values.toList(), cart.totalAmount);
      cart.clear();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(children: <Widget>[
        Card(
          margin: EdgeInsets.all(15),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: <Widget>[
                Text('Total', style: TextStyle(fontSize: 20),),
                Spacer(),
                Chip(label: Text('\$${cart.totalAmount.toStringAsFixed(2)} ', style: TextStyle(color: Theme.of(context).primaryTextTheme.title.color),), backgroundColor: Theme.of(context).primaryColor,),
                FlatButton(child: Text('ORDER NOW'), textColor: Theme.of(context).primaryColor, onPressed: addCartToOrders),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(itemCount: cart.itemCount, itemBuilder: (ctx, i) => CartItemWidget(cart.items.values.toList()[i]),),
        )
      ],),
    );
  }
}
