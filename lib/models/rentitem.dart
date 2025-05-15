import 'dart:convert';

class RentItem {
  final int? id;
  final String name;
  final int itemtypeId;

  RentItem({
    this.id,
    required this.name,
    required this.itemtypeId,
  });

  // Convert a RentItem into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'itemtypeId': itemtypeId,
    };
  }

  factory RentItem.fromMap(Map<String, dynamic> map) {
    return RentItem(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      itemtypeId: map['itemtypeId']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory RentItem.fromJson(String source) => RentItem.fromMap(json.decode(source));

  // Implement toString to make it easier to see information about
  // each rentitem when using the print statement.
  @override
  String toString() {
    return 'RentItem(id: $id, name: $name, itemtypeId: $itemtypeId)';
  }
}
