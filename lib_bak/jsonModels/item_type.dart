import 'dart:convert';

class ItemType {
  final String type;
  final int timer;
  final int price;

  ItemType({
    required this.type,
    required this.timer,
    required this.price,
  });

  // Convert a ItemType into a Map for database storage.
  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'timer': timer,
      'price': price,
    };
  }

  // Create a ItemType instance from a Map.
  factory ItemType.fromMap(Map<String, dynamic> map) {
    return ItemType(
      type: map['type'] ?? '',
      timer: map['timer']?.toInt() ?? 0,
      price: map['price']?.toInt() ?? 0,
    );
  }

  // Convert a ItemType to JSON.
  String toJson() => json.encode(toMap());

  // Create a ItemType from a JSON string.
  factory ItemType.fromJson(String source) => ItemType.fromMap(json.decode(source));

  @override
  String toString() => 'ItemType(type: $type, timer: $timer, price: $price)';
}
