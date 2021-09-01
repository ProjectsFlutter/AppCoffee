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
  double _textPage = _initialPage;

  final _pageCoffeeController = PageController(
    viewportFraction: 0.35,
    initialPage: _initialPage.toInt()
  );

  final _pageTextController = PageController(initialPage: _initialPage.toInt());

  void _coffeScrollListener(){
    setState(() {
          _currentPage = _pageCoffeeController.page!;        
        });
  }

  void _textScrollListener (){
      _textPage = _currentPage;
  }

  @override
    void initState() {
      _pageCoffeeController.addListener(  _coffeScrollListener );
      _pageTextController.addListener( _textScrollListener );
      super.initState();
    }
  
  @override
    void dispose() {
      _pageCoffeeController.removeListener(  _coffeScrollListener );
      _pageTextController.removeListener(_textScrollListener);
      _pageCoffeeController.dispose();
      _pageTextController.dispose();
      super.dispose();
    }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(
          color: Colors.black,
        ),
      ),
      body: Stack(
        children: [
          Positioned(
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
          ),
          Positioned(
            left: 0,
            top: 0,
            right: 0,
            height: 100.0,
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
                  Expanded(
                    child: PageView.builder(
                      controller: _pageTextController,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: coffees.length,
                      itemBuilder: (context, index){
                        final _opacity = (1 - (index - _textPage).abs()).clamp(0.0, 1.0);
                        return Opacity(
                          opacity: _opacity,
                          child: Padding(
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
                          )
                        );
                      }
                    )
                  ),
                  AnimatedSwitcher(
                    key: Key(coffees[_currentPage.toInt()].name),
                    duration: Duration(milliseconds: 300),
                    child: Text(
                      '\$${coffees[_currentPage.toInt()].price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 30, 
                        fontWeight: FontWeight.w400,
                        color: Colors.brown[400]
                      )),
                  )
                ],
              ),
            )
          ),
          Transform.scale(
            scale: 1.6,
            alignment: Alignment.bottomCenter,
            child: PageView.builder(
              controller: _pageCoffeeController,
              itemCount: coffees.length + 1,
              scrollDirection: Axis.vertical,
              onPageChanged: (value){
                if (value < coffees.length){
                  _pageTextController.animateToPage(value, duration: Duration(milliseconds:300), curve: Curves.easeOut);
                }
              },
              itemBuilder: (context, index){
                if (index == 0) return SizedBox.shrink();

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
                              child: CoffeeDetails(coffee: coffees[index - 1]),
                            );
                          }));
                    },
                  child: Padding(
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
                          tag: coffees[index - 1].name,
                          child: Image.asset(
                            coffees[index - 1].image, 
                            fit: BoxFit.fitHeight
                        )
                        )
                      )
                    ),
                  ),
                );
              }
            ),
          )
        ],
      ),
    );
  }
}