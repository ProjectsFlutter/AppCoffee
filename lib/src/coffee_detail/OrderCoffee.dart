import 'package:app_coffee/src/provider/CoffeeDetailProvider.dart';
import 'package:flutter/material.dart';

class OrderCoffee extends StatefulWidget {
  const OrderCoffee({required this.metadata, required this.onComplete});
  final CoffeeMetaData metadata;
  final VoidCallback onComplete;

  @override
  _OrderCoffeeState createState() => _OrderCoffeeState();
}

class _OrderCoffeeState extends State<OrderCoffee> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _coffeeExitScaleAnimation;
  late Animation<double> _coffeeExitToCartAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 1));
    _coffeeExitScaleAnimation = Tween(begin: 1.0, end: 1.3).animate(CurvedAnimation(curve: Interval(0.0, 0.2), parent: _controller));
    _coffeeExitToCartAnimation = CurvedAnimation(curve: Interval(0.4, 1.0), parent: _controller);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete();
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.metadata;
    return Positioned(
      top: data.position.dy,
      left: data.position.dx,
      width: data.size.width,
      height: data.size.height,
      child: AnimatedBuilder(
          animation: _controller,
          child: Image.memory(data.imageBytes),
          builder: (_, _child) {
            final moveX = _coffeeExitToCartAnimation.value > 0 ? data.position.dx + data.size.width / 2 * _coffeeExitToCartAnimation.value : 0.0;
            final moveY = _coffeeExitToCartAnimation.value > 0 ? -data.size.height / 1.1 * _coffeeExitToCartAnimation.value : 0.0;
            return Opacity(
              opacity: 1 - _coffeeExitToCartAnimation.value,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..translate(moveX, moveY)
                  ..scale(_coffeeExitScaleAnimation.value),
                child: Transform.scale(
                    alignment: Alignment.center,
                    scale: 1 - _coffeeExitToCartAnimation.value,
                    child: _child
                ),
              ),
            );
          }
      ),
    );
  }
}
