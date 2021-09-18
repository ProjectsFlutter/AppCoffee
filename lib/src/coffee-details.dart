// ignore_for_file: dead_code
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

class _CoffeeDetailsState extends State<CoffeeDetails> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _animationScaleOut;
  late Animation<double> _animationScaleIn;


  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animationScaleOut = CurvedAnimation(parent: _controller, curve: Interval(0.0, 0.5));
    _animationScaleIn = CurvedAnimation(parent: _controller, curve: Interval(0.5, 1.0));
    // _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
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
        actions: [_ShoppingBagButton()],
      ),
      body: Consumer<DetailsProvider>(
          builder: (context, _details, _) => 
          Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _CoffeeName(size: _size, coffee: widget.coffee),
            SizedBox(height: 5.0),
            SizedBox(
              height: _size.height * 0.5,
              child: Stack(
                children: [
                  _CoffeeImage(coffee: widget.coffee, details: _details ),
                  _CoffeePrice(size: _size, coffee: widget.coffee)
                ],
              ),
            ),
            _BottomNavigationBarCup(details: _details),
            SizedBox(height: 5.0),
            _BottomNavigationBarTemp(details: _details),

          ],
        ),
      ), 
    );
  }
}

class _ShoppingBagButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: (){},
      icon: Icon(Icons.shopping_bag_outlined),
      iconSize: 27.0,
      color: Colors.black,
    );
  }
}

class _BottomNavigationBarCup extends StatelessWidget {
  const _BottomNavigationBarCup({required this.details});
  final DetailsProvider details;

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

class _BottomNavigationBarTemp extends StatelessWidget {
  const _BottomNavigationBarTemp({required this.details});
  final DetailsProvider details;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: ()=>details.selectTemp='hot',
              child: Container(
              height: 40.0,
              decoration:(details.selectTemp == "hot")? BoxDecoration(
                color: Colors.white,
                  boxShadow: [
                        BoxShadow(blurRadius: 5.0),
                        BoxShadow(color: Colors.white, offset: Offset(0, -16)),
                        BoxShadow(color: Colors.white, offset: Offset(0, 16)),
                        BoxShadow(color: Colors.white, offset: Offset(-16, -16)),
                        BoxShadow(color: Colors.white, offset: Offset(-16, 16)),
                        BoxShadow(color: Colors.white, offset: Offset(-16, 0)),
                      ],
              ): null,
                alignment: Alignment.center,
                child: Text('Hot / Warm ', 
                style: TextStyle(
                  fontSize: 20, 
                  fontWeight: FontWeight.bold , 
                  color:(details.selectTemp != "hot")? Colors.grey[400]: Colors.black,
                )
                )
              ),
            )
          ),
          Expanded(
            child: GestureDetector(
              onTap: ()=>details.selectTemp='cold',
              child: Container(
                height: 40.0,
                decoration:(details.selectTemp == "cold")? BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                      BoxShadow(blurRadius: 5.0),
                      BoxShadow(color: Colors.white, offset: Offset(0, -16)),
                      BoxShadow(color: Colors.white, offset: Offset(0, 16)),
                      BoxShadow(color: Colors.white, offset: Offset(16, -16)),
                      BoxShadow(color: Colors.white, offset: Offset(16, 16)),
                      BoxShadow(color: Colors.white, offset: Offset(16, 0)),
                  ],
                ): null,
                alignment: Alignment.center,
                child: Text('Cold / Ice', 
                style: TextStyle(
                  fontSize: 20, 
                  fontWeight: FontWeight.bold, 
                  color:(details.selectTemp != "cold")? Colors.grey[400]: Colors.black,
                )
                )
              ),
            )
          ),
        ],
      ),
    );
  }
}

class _CoffeePrice extends StatelessWidget {
  const _CoffeePrice({required Size size, required this.coffee}) : _size = size;
  final Size _size;
  final Coffee coffee;

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
                    color: Colors.black,
                    offset: Offset(0.0, 5.0),
                    blurRadius: 40.0,
                  )
                ]
            )
        ),
      ),
    );
  }
}

class _CoffeeImage extends StatelessWidget {
  const _CoffeeImage({required this.coffee, required this.details});
  final Coffee coffee;
  final DetailsProvider details;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Hero(
        tag: coffee.name,
        child: AnimatedScale(
          scale: details.selectScale,
          duration: const Duration(milliseconds: 500),
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