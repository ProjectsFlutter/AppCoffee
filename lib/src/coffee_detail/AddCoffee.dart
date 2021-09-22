import 'package:app_coffee/src/provider/CoffeeDetailProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddCoffee extends StatefulWidget {
  const AddCoffee({required this.size});
  final Size size;

  @override
  State<AddCoffee> createState() => _AddCoffeeState();
}

class _AddCoffeeState extends State<AddCoffee> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animationAddIcon;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animationAddIcon = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
    _controller.forward();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final _coffeeDetail = Provider.of<CoffeeDetailProvider>(context, listen: false);
      _coffeeDetail.notifierAddCoffeeAnimation.addListener(() {
        if (_coffeeDetail.notifierAddCoffeeAnimation.value) {
        if (!mounted) return;
         _controller.reverse();
        }
      });
    });
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final _coffeeDetail = Provider.of<CoffeeDetailProvider>(context, listen: false);
   _coffeeDetail.notifierAddCoffeeAnimation = false;
   
    return Positioned(
        top: widget.size.height * 0.02,
        right: widget.size.width * 0.2,
        child: AnimatedBuilder(
          animation: _controller,
          child: Container(
            decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 9,
                offset: Offset(9, 9),
              )
            ]),
            child: IconButton(
              onPressed: ()=> _coffeeDetail.startAnimationCoffee(),
              icon: Icon(Icons.add_circle_outlined, size: 50.0),
              color: Colors.white,
            ),
          ),
          builder: (BuildContext context, Widget? child) {
            return Transform.translate(
              offset: Offset(200 * _animationAddIcon.value, 0.0),
              child: child,
            );
          },
        )
    );
  }
}
