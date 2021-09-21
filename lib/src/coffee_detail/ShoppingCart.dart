import 'package:app_coffee/src/provider/CoffeeDetailProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShoppingCart extends StatefulWidget {
  @override
  State<ShoppingCart> createState() => ShoppingCartState();
}

class ShoppingCartState extends State<ShoppingCart> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animationScaleOut;
  late Animation<double> _animationScaleIn;
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _animationScaleOut = CurvedAnimation(parent: _controller, curve: Interval(0.0, 0.5));
    _animationScaleIn = CurvedAnimation(parent: _controller, curve: Interval(0.5, 1.0));

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final _coffeeDetail = Provider.of<CoffeeDetailProvider>(context, listen: false);
      _coffeeDetail.notifierCartIconAnimation.addListener(() {
        _counter = _coffeeDetail.notifierCartIconAnimation.value;
        _controller.forward(from: 0.0);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (_, _child) {
          late double _scale;
          const _scaleFactor = 0.5;
          if (_animationScaleOut.value < 1.0) {
            _scale = 1 + _scaleFactor * _animationScaleOut.value;
          } else if (_animationScaleIn.value <= 1.0) {
            _scale = (1 + _scaleFactor) - _scaleFactor * _animationScaleIn.value;
          }
          return Transform.scale(
            alignment: Alignment.center,
            scale: _scale,
            child: Stack(children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.shopping_bag_outlined),
                iconSize: 27.0,
                color: Colors.black,
              ),
              if (_animationScaleOut.value > 0.0)
                Positioned(
                  top: 8.0,
                  right: 0.0,
                  child: Transform.scale(
                    scale: _animationScaleOut.value,
                    child: CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.red,
                        child: Text(_counter.toString())
                    ),
                  ),
                )
            ]),
          );
        }
    );
  }
}
