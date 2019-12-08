import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_flutter_app/providers/cart.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;

  CartItemWidget(this.cartItem);

  @override
  Widget build(BuildContext context) {

    return Dismissible(
      key: ValueKey(cartItem.id),
      direction: DismissDirection.endToStart,

      confirmDismiss: (dir) {
        return showDialog(context: context, builder: (ctx) => AlertDialog(
          title: Text('Are you sure?'),
          content: Text('Do you want to remove the item from the card?'),
          actions: <Widget>[
            FlatButton(child: Text('No'), onPressed: () {
              Navigator.of(ctx).pop(false);
            },),
            FlatButton(child: Text('Yes'), onPressed: () {
              Navigator.of(context).pop(true);
            },),
          ],
        ),);
      },
      background: Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        padding: EdgeInsets.only(right: 15),
        color: Theme.of(context).errorColor,
        child: Icon(Icons.delete, size: 40, color: Colors.white,),
        alignment: Alignment.centerRight,
      ),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4,),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(child: FittedBox(child: Padding(padding: EdgeInsets.all(5), child: Text('\$${cartItem.price}'))),),
            title: Text('${cartItem.title}'),
            subtitle: Text('Total: \$${(cartItem.price * cartItem.quantity).toStringAsFixed(2)}'),
            trailing: Text('${cartItem.quantity}x'),
          ),
        ),
      ),
      onDismissed: (dir) {
        Provider.of<Cart>(context, listen: false).removeItem(cartItem.id);
      },
    );
  }
}
