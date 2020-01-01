import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_flutter_app/providers/cart.dart';
import 'package:shop_flutter_app/providers/products_provider.dart';
import 'package:shop_flutter_app/screens/cart_screen.dart';
import 'package:shop_flutter_app/widget/app_drawer.dart';
import 'package:shop_flutter_app/widget/badge.dart';
import 'package:shop_flutter_app/widget/product_grid.dart';

enum FilterOptions {
  favourites,
  all,
  logout
}

class ProductOverviewScreen extends StatefulWidget {
  static const pathName = "/product-overview";

  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showOnlyFavourites = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {

    super.initState();
  }


  @override
  void didChangeDependencies() {
    if (_isInit) {
      _isInit = false;
      setState(() {_isLoading = true;});
      Provider.of<ProductsProvider>(context).fetchAndSetProducts().then((_) {
        setState(() {_isLoading = false;});
      });
    }
    super.didChangeDependencies();
  }

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
      body: RefreshIndicator(
        onRefresh: () {
          return Provider.of<ProductsProvider>(context).fetchAndSetProducts();
        },
        child: _isLoading ? Center(child: CircularProgressIndicator(),) : new ProductGrid(_showOnlyFavourites),
      ),
    );
  }
}














