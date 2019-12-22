import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_flutter_app/providers/cart.dart';
import 'package:shop_flutter_app/providers/order.dart';
import 'package:shop_flutter_app/widget/cart_item.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

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
                FlatButton(child: _isLoading ? CircularProgressIndicator() : Text('ORDER NOW'), textColor: Theme.of(context).primaryColor, onPressed: (cart.items.length <= 0 || _isLoading) ? null : () async {
                  setState(() {
                    _isLoading = true;
                  });
                  await Provider.of<Order>(context, listen: false).addOrder(cart.items.values.toList(), cart.totalAmount);
                  setState(() {
                    _isLoading = false;
                    cart.clear();
                  });
                }),
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
