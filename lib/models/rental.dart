import 'dart:convert';

class Rental {
  final int? id;
  final int itemId;
  final String itemType;
  final String itemName;
  final String time;
  final String date;
  final int price;
  final int status;

  Rental({
    this.id,
    required this.itemId,
    required this.itemType,
    required this.itemName,
    required this.time,
    required this.date,
    required this.price,
    required this.status,
  });

  // Convert a Rental into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'itemId': itemId,
      'itemType': itemType,
      'itemName': itemName,
      'time': time,
      'date': date,
      'price': price,
      'status': status,
    };
  }

  factory Rental.fromMap(Map<String, dynamic> map) {
    return Rental(
      id: map['id']?.toInt() ?? 0,
      itemId: map['id']?.toInt() ?? 0,
      itemType: map['name'] ?? '',
      itemName: map['name'] ?? '',
      time: map['name'] ?? '',
      date: map['name'] ?? '',
      price: map['id']?.toInt() ?? 0,
      status: map['id']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Rental.fromJson(String source) => Rental.fromMap(json.decode(source));

  // Implement toString to make it easier to see information about
  // each rental when using the print statement.
  @override
  String toString() {
    return 'Rental(id: $id, itemId: $itemId, itemType: $itemType, itemName: $itemName, time: $time, date: $date, price: $price, status: $status)';
  }
}
