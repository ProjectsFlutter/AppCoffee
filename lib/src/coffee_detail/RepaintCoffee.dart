import 'package:app_coffee/src/coffee_detail/OrderCoffee.dart';
import 'package:app_coffee/src/provider/CoffeeDetailProvider.dart';
import 'package:app_coffee/src/coffee.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class RepaintCoffee extends StatefulWidget {
  const RepaintCoffee({required this.coffee});
  final Coffee coffee;

  @override
  State<RepaintCoffee> createState() => RepaintCoffeeState();
}

class RepaintCoffeeState extends State<RepaintCoffee> {
  final _keyCoffee = GlobalKey();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final _coffeeDetail = Provider.of<CoffeeDetailProvider>(context, listen: false);
      _coffeeDetail.notifierCoffeAnimation.addListener(() {
        if (_coffeeDetail.notifierCoffeAnimation.value) {
          _addCoffeeToCart();
        }
      });
    });
  }
 
  @override
  Widget build(BuildContext context) {
    final _coffeeDetail = Provider.of<CoffeeDetailProvider>(context);
    return Positioned.fill(
      child: Hero(
          tag: widget.coffee.name,
          child: ValueListenableBuilder<CoffeeMetaData?>(
              valueListenable: _coffeeDetail.notifierCoffeeImage,
              builder: (context, data, child) {
                if (data != null) {
                  Future.microtask(() => _startCoffeeBoxAnimation(data));
                }
                return RepaintBoundary(
                  key: _keyCoffee,
                  child: AnimatedScale(
                      scale: _coffeeDetail.selectScale,
                      duration: const Duration(milliseconds: 500),
                      child: Image.asset(widget.coffee.image,
                          fit: BoxFit.fitHeight)
                  ),
                );
              }
          )
      ),
    );
  }
  
  void _addCoffeeToCart() {
    if (!mounted) return;
    final _coffeeDetail = Provider.of<CoffeeDetailProvider>(context, listen: false);
    if (_keyCoffee.currentContext != null) {
      RenderRepaintBoundary boundary = _keyCoffee.currentContext!.findRenderObject() as RenderRepaintBoundary;
      _coffeeDetail.tranformToImage(boundary);
    }
  }

  void _startCoffeeBoxAnimation(CoffeeMetaData data) {
   final _coffeeDetail = Provider.of<CoffeeDetailProvider>(context, listen: false);
    if (_overlayEntry == null) {
      _overlayEntry = OverlayEntry(builder: (context) {
        return OrderCoffee(
            metadata: data,
            onComplete: () {
              _overlayEntry!.remove();
              _overlayEntry = null;
             _coffeeDetail.reset();
            });
      });
      Overlay.of(context)!.insert(_overlayEntry!);
    }
  }
}

