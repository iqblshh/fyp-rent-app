import 'dart:convert';

class ItemType {
  final int? id;
  final String name;
  final int timer;
  final int price;

  ItemType({
    this.id,
    required this.name,
    required this.timer,
    required this.price,
  });

  // Convert a ItemType into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'timer': timer,
      'price': price,
    };
  }

  factory ItemType.fromMap(Map<String, dynamic> map) {
    return ItemType(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      timer: map['timer']?.toInt() ?? 0,
      price: map['price']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemType.fromJson(String source) => ItemType.fromMap(json.decode(source));

  // Implement toString to make it easier to see information about
  // each itemtype when using the print statement.
  @override
  String toString() => 'ItemType(id: $id, name: $name, timer: $timer, price: $price)';
}
