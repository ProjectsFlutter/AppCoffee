import 'package:app_coffee/src/coffee-home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/provider/CoffeeDetailProvider.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CoffeeDetailProvider() ,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Coffee App',
        home: CoffeeHome()
      ),
    );
  }
}