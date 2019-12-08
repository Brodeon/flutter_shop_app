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
          onPressed: () {
            showDialog(context: context, builder: (ctx) => AlertDialog(
              title: Text('Remove product'),
              content: Text('Do you realy want to remove this product?', textAlign: TextAlign.left,),
              actions: <Widget>[
                FlatButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text('Delete'),
                  onPressed: () {
                    Provider.of<ProductsProvider>(context, listen: false).deleteItem(id);
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
          },
          color: Theme.of(context).errorColor,
        )
      ],),
    );
  }
}
