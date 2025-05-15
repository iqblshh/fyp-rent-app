import 'dart:convert';

class RentItem {
  final int? id;
  final String type;
  final String name;

  RentItem({
    this.id,
    required this.type,
    required this.name,
  });

  // Convert a RentItem into a Map for database storage.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'name': name,
    };
  }

  // Create a RentItem instance from a Map.
  factory RentItem.fromMap(Map<String, dynamic> map) {
    return RentItem(
      id: map['id']?.toInt() ?? 0,
      type: map['type'] ?? '',
      name: map['name'] ?? '',
    );
  }

  // Convert a RentItem to JSON.
  String toJson() => json.encode(toMap());

  // Create a RentItem from a JSON string.
  factory RentItem.fromJson(String source) => RentItem.fromMap(json.decode(source));

  @override
  String toString() {
    return 'RentItem(id: $id, type: $type, name: $name)';
  }
}
