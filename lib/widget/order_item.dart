import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_flutter_app/providers/order.dart';

class OrderItemWidget extends StatefulWidget {
  final OrderItem order;

  OrderItemWidget(this.order);

  @override
  _OrderItemWidgetState createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> with TickerProviderStateMixin {
  var _expanded = false;
  AnimationController _controller;
  Animation<double> _rotationAnimation;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    _rotationAnimation = Tween(begin: 0.0, end: 0.5).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(children: <Widget>[
        ListTile(
          title: Text('\$${widget.order.amount.toStringAsFixed(2)}'),
          subtitle: Text('${DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime)}'),
          trailing: RotationTransition(
            turns: _rotationAnimation,
            child: IconButton(icon: Icon(Icons.expand_more), onPressed: () {
              setState(() {
                this._expanded = !this._expanded;
              });
              if (_expanded) {
                _controller.forward();
              } else {
                _controller.reverse();
              }
            },),
          ),
        ),
        AnimatedContainer(
          padding: EdgeInsets.symmetric(horizontal: 10),
          curve: Curves.easeInOut,
          duration: Duration(milliseconds: 300,),
          height: _expanded ? math.min(widget.order.products.length * 20.0 + 10, 180) : 0,
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
