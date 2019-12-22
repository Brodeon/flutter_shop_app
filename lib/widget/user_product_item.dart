import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_flutter_app/providers/products_provider.dart';
import 'package:shop_flutter_app/screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String title;
  final String imgUrl;
  final String id;


  UserProductItem(this.title, this.imgUrl, this.id);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(this.title),
      leading: CircleAvatar(backgroundImage: NetworkImage(imgUrl),),
      trailing: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            Navigator.of(context).pushNamed(EditProductScreen.routeName, arguments: id);
          },
          color: Theme.of(context).primaryColor,
        ),
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () async {
            try {
              await Provider.of<ProductsProvider>(context, listen: false).deleteItem(id);
            } catch(httpException) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('Deleting failed'),
                ),
              );
            }
          },
          color: Theme.of(context).errorColor,
        )
      ],),
    );
  }
}
