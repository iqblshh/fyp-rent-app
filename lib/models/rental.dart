import 'dart:convert';

class Rental {
  final int? id;
  final int rentitemId;
  final String itemType;
  final String itemName;
  final String statime;
  final String endtime;
  final String date;
  final int price;
  final int paid;
  final int status;

  Rental({
    this.id,
    required this.rentitemId,
    required this.itemType,
    required this.itemName,
    required this.statime,
    required this.endtime,
    required this.date,
    required this.price,
    required this.paid,
    required this.status,
  });

  // Convert a Rental into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'rentitemId': rentitemId,
      'itemType': itemType,
      'itemName': itemName,
      'statime': statime,
      'endtime': endtime,
      'date': date,
      'price': price,
      'paid': paid,
      'status': status,
    };
  }

  factory Rental.fromMap(Map<String, dynamic> map) {
    return Rental(
      id: map['id']?.toInt() ?? 0,
      rentitemId: map['rentitemId']?.toInt() ?? 0,
      itemType: map['itemType'] ?? '',
      itemName: map['itemName'] ?? '',
      statime: map['statime'] ?? '',
      endtime: map['endtime'] ?? '',
      date: map['date'] ?? '',
      price: map['price']?.toInt() ?? 0,
      paid: map['paid']?.toInt() ?? 0,
      status: map['status']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Rental.fromJson(String source) => Rental.fromMap(json.decode(source));

  // Implement toString to make it easier to see information about
  // each rental when using the print statement.
  @override
  String toString() {
    return 'Rental(id: $id, rentitemId: $rentitemId, itemType: $itemType, itemName: $itemName, statime: $statime, endtime: $endtime, date: $date, price: $price, paid: $paid, status: $status)';
  }
}
