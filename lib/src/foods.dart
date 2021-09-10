import 'dart:math';

double _doubleInRange(Random source, num start, num end) => source.nextDouble() * (end - start) + start;
final random = Random();
final foods = List.generate(_names.length, (index) => Food(
        image: 'assets/foods/${index + 1}.png',
        name: _names[index],
        price: _doubleInRange(random, 3, 7)
)
);

class Food {
  Food({
    required this.name,
    required this.image,
    required this.price,
  });

  final String name;
  final String image;
  final double price;
}

final _names = [
  'Bacon Sandwich',
  'Buffalo Big Mac Burger',
  'Submarine Sandwich',
  'Baguette Breakfast',
  'Pan Bagnat Sandwich'
];
