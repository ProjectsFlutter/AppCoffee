import 'package:app_coffee/src/coffee-details.dart';
import 'package:app_coffee/src/coffee.dart';
import 'package:flutter/material.dart';

 const double _initialPage = 5.0;

class CoffeeList extends StatefulWidget {
  @override
  _CoffeeListState createState() => _CoffeeListState();
}

class _CoffeeListState extends State<CoffeeList> {
  
  double _currentPage = _initialPage;

  final _pageCoffeeController = PageController(
    viewportFraction: 0.35,
    initialPage: _initialPage.toInt()
  );

  final _pageTextController = PageController(
    initialPage: _initialPage.toInt()
  );

  final _pagePriceController = PageController(
    initialPage: _initialPage.toInt()
  );

  void _coffeScrollListener(){
    setState((){
      _currentPage = _pageCoffeeController.page!;        
    });
  }

  @override
    void initState() {
      _pageCoffeeController.addListener(  _coffeScrollListener );
      super.initState();
    }
  
  @override
    void dispose() {
      _pageCoffeeController.removeListener(  _coffeScrollListener );
      _pageCoffeeController.dispose();
      super.dispose();
    }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.brown,
          onPressed: (){
            _pageCoffeeController.animateToPage(5, duration: Duration(seconds:1), curve: Curves.linear);
            // Navigator.push(context,MaterialPageRoute(builder: (context) => CoffeeHome()));
          },
        ),
      ),
      body: Stack(
        children: [
          _GradientCircle(size: _size),
          Positioned(
            left: 0,
            top: 0,
            right: 0,
            height: 150.0,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 1.0, end: 0.0),
              builder: (context, value, child) {
                return Transform.translate(
                      offset: Offset(0, -100 * value), 
                      child: child
                );
              },
              duration: Duration(milliseconds: 500),
              child: Column(
                children: [
                  _CoffeeName(pageTextController: _pageTextController, size: _size),
                  _CoffeePrice(pagePriceController: _pagePriceController, size: _size)
                ],
              ),
            )
          ),
          Transform.scale(
            scale: 1.7,
            alignment: Alignment.bottomCenter,
            child: PageView.builder(
              controller: _pageCoffeeController,
              itemCount: coffees.length + 1,
              scrollDirection: Axis.vertical,
              onPageChanged: (value){
                if (value < coffees.length){
                  _pageTextController.animateToPage(value, duration: Duration(milliseconds:300), curve: Curves.fastOutSlowIn);
                  _pagePriceController.animateToPage(value, duration: Duration(milliseconds:400), curve: Curves.fastOutSlowIn);
                }
              },
              itemBuilder: (context, index){
                if (index == 0) return SizedBox.shrink();
                final _coffee =  coffees[index - 1];
                final _result = _currentPage - index + 1;
                final _value = -0.4 * _result + 1; 
                final _opacity = _value.clamp(0.0, 1.0);

                return GestureDetector(
                  onTap: () {
                      Navigator.of(context).push(PageRouteBuilder(
                          transitionDuration: Duration(microseconds: 650),
                          pageBuilder: (context, animation, _) {
                            return FadeTransition(
                              opacity: animation,
                              child: CoffeeDetails(coffee: _coffee),
                            );
                          }));
                    },
                  child: _CoffeeImage(size: _size, value: _value, opacity: _opacity, coffee: _coffee),
                );
              }
            ),
          )
        ],
      ),
    );
  }
}

class _CoffeePrice extends StatelessWidget {
  const _CoffeePrice({required PageController pagePriceController, required Size size}): _pagePriceController = pagePriceController, _size = size;
  final PageController _pagePriceController;
  final Size _size;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: PageView.builder(
            controller: _pagePriceController,
            scrollDirection: Axis.vertical,
            physics: NeverScrollableScrollPhysics(),
            itemCount: coffees.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: _size.width * 0.2),
                child: Text(
                  '\$${coffees[index].price.toStringAsFixed(2)}',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w400, color: Colors.brown[400])
                ),
              );
            }
        )
    );
  }
}


class _CoffeeName extends StatelessWidget {
  const _CoffeeName({required PageController pageTextController, required Size size}) : _pageTextController = pageTextController,  _size = size;
  final PageController _pageTextController;
  final Size _size;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PageView.builder(
        controller: _pageTextController,
        physics: NeverScrollableScrollPhysics(),
        itemCount: coffees.length,
        itemBuilder: (context, index){
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: _size.width * 0.2 ),
            child: Hero(
              tag: 'text_${ coffees[index].name }',
              child: Material(
                child: Text(
                  coffees[index].name,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.brown[900]),
                ),
              ),
            ),
          );
        }
      )
    );
  }
}

class _GradientCircle extends StatelessWidget {
  final Size _size;
  const _GradientCircle({required Size size}) : _size = size;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 20,
      right: 20,
      bottom: -_size.height * 0.22,
      height: _size.height * 0.3,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.brown,
              blurRadius: 90,
              spreadRadius: 45
            )
          ]
        ),
      ),
    );
  }
}

class _CoffeeImage extends StatelessWidget {
  final Size _size;
  final double _value;
  final double _opacity;
  final Coffee _coffee;

  const _CoffeeImage({
    required Size size,
    required double value,
    required double opacity,
    required Coffee coffee,
  }) : _size = size, _value = value, _opacity = opacity, _coffee = coffee;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Transform(
        alignment: Alignment.bottomCenter,
        transform: Matrix4.identity()
        ..setEntry(3,2,0.001)
        ..translate(0.0, _size.height / 2.6 * (1 - _value).abs())
        ..scale(_value),
        child: Opacity(
          opacity: _opacity,
          child: Hero(
            tag: 'image_${_coffee.name}',
            child: Image.asset(
              _coffee.image, 
              fit: BoxFit.fitHeight
          )
          )
        )
      ),
    );
  }
}