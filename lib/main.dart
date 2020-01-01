import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_flutter_app/helpers/custom_route.dart';
import 'package:shop_flutter_app/providers/auth.dart';
import 'package:shop_flutter_app/providers/cart.dart';
import 'package:shop_flutter_app/providers/order.dart';
import 'package:shop_flutter_app/screens/auth-screen.dart';
import 'package:shop_flutter_app/screens/cart_screen.dart';
import 'package:shop_flutter_app/screens/edit_product_screen.dart';
import 'package:shop_flutter_app/screens/orders_screen.dart';
import 'package:shop_flutter_app/screens/product_detail_screen.dart';
import 'package:shop_flutter_app/screens/splash-screen.dart';
import 'package:shop_flutter_app/screens/user_products_screen.dart';

import 'providers/products_provider.dart';
import 'screens/products_overview_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(builder: (_) => Auth(),),
      ChangeNotifierProxyProvider<Auth, ProductsProvider>(update: (_, auth, previousProvider) => ProductsProvider(auth.token, auth.userId, previousProvider == null ? [] : previousProvider.products),),
      ChangeNotifierProvider(builder: (_) => Cart(),),
      ChangeNotifierProxyProvider<Auth, Order>(update: (_, auth, previousOrder) => Order(auth.token, auth.userId, previousOrder == null ? [] : previousOrder.orders),),
    ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android: CustomPageTransitionBuilder(),
              TargetPlatform.iOS: CustomPageTransitionBuilder()
            }),
          ),
          home: auth.isAuth? ProductOverviewScreen() : FutureBuilder(future: auth.tryAutoLogin(), builder: (ctx, snapshot) => snapshot.connectionState == ConnectionState.waiting ? SplashScreen() : AuthScreen(),),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.pathName: (ctx) => OrdersScreen(),
            UserProductsScreen.pathName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
            ProductOverviewScreen.pathName: (ctx) => ProductOverviewScreen(),
          },
        ),
      ),
    );
  }
}
