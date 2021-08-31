import 'package:app_coffee/src/coffee.dart';
import 'package:flutter/material.dart';

class CoffeeList extends StatefulWidget {
  @override
  _CoffeeListState createState() => _CoffeeListState();
}

class _CoffeeListState extends State<CoffeeList> {
  final _pageCoffeeController = PageController(
    viewportFraction: 0.35
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            right: 0,
            height: 100.0,
            child: Container(
              color: Colors.red,
            ) 
          ),
          PageView.builder(
            controller: _pageCoffeeController,
            itemCount: coffees.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index){
              return Image.asset(coffees[index].image);
            }
          )
        ],
      ),
    );
  }
}