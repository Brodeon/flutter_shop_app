import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_flutter_app/providers/cart.dart';
import 'package:shop_flutter_app/screens/cart_screen.dart';
import 'package:shop_flutter_app/widget/app_drawer.dart';
import 'package:shop_flutter_app/widget/badge.dart';
import 'package:shop_flutter_app/widget/product_grid.dart';

enum FilterOptions {
  favourites,
  all
}

class ProductOverviewScreen extends StatefulWidget {

  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showOnlyFavourites = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (selectedValue) {
              switch (selectedValue) {
                case FilterOptions.favourites:
                  setState(() {
                    _showOnlyFavourites = true;
                  });
                  break;
                case FilterOptions.all:
                  setState(() {
                    _showOnlyFavourites = false;
                  });
                  break;
              }
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(child: Text('Only Favourites'), value: FilterOptions.favourites,),
              PopupMenuItem(child: Text('Show All'), value: FilterOptions.all,),
            ],
          ),
          Consumer<Cart>(builder: (_, cart, ch) => Badge(
            child: IconButton(
              icon: ch,
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
            value: cart.itemCount.toString(),),
            child: Icon(Icons.shopping_cart, color: Colors.white,),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: new ProductGrid(_showOnlyFavourites),
    );
  }
}














