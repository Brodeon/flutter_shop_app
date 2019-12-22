import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_flutter_app/providers/order.dart';

class OrderItemWidget extends StatefulWidget {
  final OrderItem order;

  OrderItemWidget(this.order);

  @override
  _OrderItemWidgetState createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(children: <Widget>[
        ListTile(
          title: Text('\$${widget.order.amount.toStringAsFixed(2)}'),
          subtitle: Text('${DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime)}'),
          trailing: IconButton(icon: Icon(this._expanded ? Icons.expand_less : Icons.expand_more), onPressed: () {
            setState(() {
              this._expanded = !this._expanded;
            });
          },),
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 100,),
          height: _expanded ? min(widget.order.products.length * 20.0 + 10, 180) : 0,
          child: ListView(children: widget.order.products.map((prod) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(prod.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                Text('${prod.quantity}x \$${prod.price}', style: TextStyle(fontSize: 18, color: Colors.grey),),
              ],
            );
          }).toList()),
        ),
      ],),
    );
  }
}
