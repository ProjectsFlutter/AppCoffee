import 'package:app_coffee/src/coffee.dart';
import 'package:app_coffee/src/coffee_detail/AddCoffee.dart';
import 'package:app_coffee/src/coffee_detail/CoffeeSize.dart';
import 'package:app_coffee/src/coffee_detail/CoffeeTemperature.dart';
import 'package:app_coffee/src/coffee_detail/RepaintCoffee.dart';
import 'package:app_coffee/src/coffee_detail/ShoppingCart.dart';
import 'package:app_coffee/src/provider/CoffeeDetailProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class CoffeeDetail extends StatefulWidget {
 
  final Coffee coffee;
  const CoffeeDetail({Key? key,required this.coffee}) : super(key: key);

  @override
  _CoffeeDetailState createState() => _CoffeeDetailState();
}

class _CoffeeDetailState extends State<CoffeeDetail>{

  @override
  Widget build(BuildContext context) {
    
  final _coffeeDetail = Provider.of<CoffeeDetailProvider>(context, listen: false);
  final _size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(
          onPressed: (){
            _coffeeDetail.notifierAddCoffeeAnimation = true;
            Navigator.maybePop(context);
          },
          color: Colors.black
        ),
        actions: [ShoppingCart()],
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _CoffeeName(size: _size, coffee: widget.coffee),
            SizedBox(height: 5.0),
            SizedBox(
              height: _size.height * 0.5,
              child: Stack(
                children: [
                  RepaintCoffee(coffee: widget.coffee),
                  _CoffeePrice(size: _size, coffee: widget.coffee),
                  AddCoffee(size: _size),
                ],
              ),
            ),
            CoffeeSize(),
            SizedBox(height: 5.0),
            CoffeeTemperature(),
          ],
        ),
    );
  }
}

class _CoffeeName extends StatelessWidget {
  const _CoffeeName({required this.size, required this.coffee});
  final Size size;
  final Coffee coffee;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.2),
      child: Hero(
        tag:  'text_${coffee.name}',
        child: Material(
          color: Colors.white,
          child: Text(
            coffee.name,
            maxLines: 2, 
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize:30, 
              fontWeight: FontWeight.w600
            )
          ),
        ),
      ),
    );
  }
}

class _CoffeePrice extends StatelessWidget {
  const _CoffeePrice({required this.size, required this.coffee});
  final Size size;
  final Coffee coffee;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: size.width * 0.05,
      bottom: 0,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 1.0, end: 0.0),
        builder: (context, value, child) {
          return Transform.translate(
              offset: Offset(-100 * value, 240 * value), child: child);
        },
        duration: Duration(milliseconds: 500),
        child: Text('\$${coffee.price.toStringAsFixed(2)}',
            style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                shadows: [
                  BoxShadow(
                    color: Colors.black,
                    offset: Offset(0.0, 5.0),
                    blurRadius: 40.0,
                  )
                ])),
      ),
    );
  }
}
