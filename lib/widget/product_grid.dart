import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_flutter_app/providers/products_provider.dart';

import 'product_item.dart';

class ProductGrid extends StatelessWidget {

  final bool _showFav;

  ProductGrid(this._showFav);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    print(productsData.products);
    final products = _showFav ? productsData.favouriteItems : productsData.products;
    
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        childAspectRatio: 3/2,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (ctx, i) => ChangeNotifierProvider(builder: (_) => products[i], child: ProductItem(),),
      itemCount: products.length,
      padding: const EdgeInsets.all(10.0),
    );
  }
}