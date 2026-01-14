import 'package:flutter/foundation.dart';

class ShoppingItem {
  String id;
  String name;
  int quantity;

  ShoppingItem({required this.name, this.quantity = 1, String? id})
      : id = id ?? UniqueKey().toString();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
    };
  }

  factory ShoppingItem.fromMap(Map<String, dynamic> map) {
    return ShoppingItem(
      id: map['id'] ?? UniqueKey().toString(),
      name: map['name'],
      quantity: map['quantity'],
    );
  }
}
