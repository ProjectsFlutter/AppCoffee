import 'dart:math';

double _doubleInRange(Random source, num start, num end) => source.nextDouble() * (end - start) + start;
final random = Random();
final coffees = List.generate(_names.length, (index) => Coffee(
        image: 'assets/coffees/${index + 1}.png',
        name: _names[index],
        price: _doubleInRange(random, 3, 7)
)
);

class Coffee {
  Coffee({
    required this.name,
    required this.image,
    required this.price,
  });

  final String name;
  final String image;
  final double price;
}

final _names = [
  'Caramel Macchiato',
  'Caramel Cold Drink',
  'Iced Coffe Mocha',
  'Caramelized Pecan Latte',
  'Toffee Nut Latte',
  'Capuchino Cold Nuts',
  'Toffee Nut Iced Latte',
  'Americano Trump',
  'Vietnamese-Style Iced Coffee',
  'Black Tea Bidden ',
  'Classic Irish Coffee',
  'Toffee Nut Crunch Latte',
];
