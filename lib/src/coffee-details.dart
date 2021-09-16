import 'package:app_coffee/src/coffee.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/details-provider.dart';

class CoffeeDetails extends StatefulWidget {
 
  final Coffee coffee;
  const CoffeeDetails({Key? key,required this.coffee}) : super(key: key);

  @override
  _CoffeeDetailsState createState() => _CoffeeDetailsState();
}

class _CoffeeDetailsState extends State<CoffeeDetails> {
 
  @override
  Widget build(BuildContext context) {
    
  final _size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(
          color: Colors.black
        ),
      ),
      body: Consumer<DetailsProvider>(
          builder: (context, _details, _) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _CoffeeName(size: _size, coffee: widget.coffee),
            SizedBox(height: 30),
            SizedBox(
              height: _size.height * 0.5,
              child: Stack(
                children: [
                  _CoffeeImage(coffee: widget.coffee, details: _details ),
                  _CoffeePrice(size: _size, coffee: widget.coffee)
                ],
              ),
            ),
            _BottomNavigationBar(details: _details)
          ],
        ),
      ), 
    );
  }
}

class _BottomNavigationBar extends StatelessWidget {
  final DetailsProvider details;
  const _BottomNavigationBar({required this.details});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.transparent,
      selectedItemColor: Colors.brown,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: true,
      showUnselectedLabels: false,
      selectedFontSize: 18,
      elevation: 0,
      currentIndex: details.selectItem,
      onTap: (index)=> details.selectItem = index,
      items: [
        BottomNavigationBarItem(
            icon: ImageIcon(AssetImage("assets/coffees/taza_s.png"), size: 50), 
            label: "S",
        ),
        BottomNavigationBarItem(
            icon: ImageIcon(AssetImage("assets/coffees/taza_m.png"), size: 65), 
            label: "M",
        ),
        BottomNavigationBarItem(
            icon: ImageIcon(AssetImage("assets/coffees/taza_l.png"), size: 60), 
            label: "L",
        )
      ],
    );
  }
}

class _CoffeePrice extends StatelessWidget {
  final Size _size;
  final Coffee coffee;
  const _CoffeePrice({required Size size, required this.coffee}) : _size = size;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _size.width * 0.05,
      bottom: 0,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 1.0, end: 0.0),
        builder: (context, value, child){
          return Transform.translate(
            offset: Offset(-100 * value , 240 * value),
            child: child
          );
        },
        duration: Duration(milliseconds: 500),
        child: Text('\$${coffee.price.toStringAsFixed(2)}',
            style: TextStyle(
                fontSize: 50, 
                fontWeight: FontWeight.w900,
                color: Colors.white,
                shadows: [
                  BoxShadow(
                    color: Colors.black45,
                    blurRadius: 10,
                    spreadRadius: 20
                  )
                ]
            )
        ),
      ),
    );
  }
}

class _CoffeeImage extends StatelessWidget {
  final Coffee coffee;
  final DetailsProvider details;
  const _CoffeeImage({required this.coffee, required this.details});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Hero(
        tag: coffee.name,
        child: AnimatedScale(
          scale: details.scale,
          duration: Duration(milliseconds: 500),
          child: Image.asset(coffee.image, fit: BoxFit.fitHeight)
        )
      ),
    );
  }
}

class _CoffeeName extends StatelessWidget {
  final Size _size;
  final Coffee coffee;
  const _CoffeeName({required Size size,required this.coffee}) : _size = size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _size.width * 0.2),
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