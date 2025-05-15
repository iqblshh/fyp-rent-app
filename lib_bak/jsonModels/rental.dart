import 'dart:convert';

class Rental {
  final int? id;
  final String type;
  final String name;
  final String time;
  final String date;
  final int price;

  Rental({
    this.id,
    required this.type,
    required this.name,
    required this.time,
    required this.date,
    required this.price,
  });

  // Convert a Rental into a Map for database storage.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'name': name,
      'time': time,
      'date': date,
      'price': price,
    };
  }

  // Create a Rental instance from a Map.
  factory Rental.fromMap(Map<String, dynamic> map) {
    return Rental(
      id: map['id']?.toInt() ?? 0,
      type: map['type'] ?? '',
      name: map['name'] ?? '',
      time: map['time'] ?? '',
      date: map['date'] ?? '',
      price: map['price']?.toInt() ?? 0,
    );
  }

  // Convert a Rental to JSON.
  String toJson() => json.encode(toMap());

  // Create a Rental from a JSON string.
  factory Rental.fromJson(String source) => Rental.fromMap(json.decode(source));

  @override
  String toString() => 'Rental(id: $id, type: $type, name: $name, time: $time, date: $date, price: $price)';
}
