import 'package:app_coffee/src/coffee-list.dart';
import 'package:flutter/material.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light(), 
      child: CoffeeList()
    );
  }
}