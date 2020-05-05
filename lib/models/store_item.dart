import 'package:flutter/foundation.dart';

class StoreItem {
  final int id;
  final String name;
  final String description;
  final int cost;
  final int qty;
  final bool comingSoon;
  final String type;
  final String imageUrl;
  final List<dynamic> sizes;

  const StoreItem({
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.cost,
    @required this.qty,
    @required this.comingSoon,
    @required this.type,
    @required this.imageUrl,
    this.sizes,
  });

  factory StoreItem.fromJson(Map<String, dynamic> json) {
    return StoreItem(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      cost: json['cost'],
      qty: json['qty'],
      comingSoon: (json['coming_soon'] == 1),
      type: json['type']['name'],
      imageUrl: json['imageFile']['location'],
      sizes: json['availableSizes'],
    );
  }

  static Map toMap(StoreItem storeItem) {
    var mapData = new Map();
    mapData['id'] = storeItem.id;
    mapData['name'] = storeItem.name;
    mapData['description'] = storeItem.description;
    mapData['cost'] = storeItem.cost;
    mapData['qty'] = storeItem.qty;
    mapData['comingSoon'] = storeItem.comingSoon;
    mapData['type'] = storeItem.type;
    mapData['imageUrl'] = storeItem.imageUrl;
    mapData['availableSizes'] = storeItem.sizes;
    return mapData;
  }

  List<String> getSizes() {
    List<String> results = [];

    for (var sizeObj in this.sizes) {
      results.add(sizeObj['size']);
    }

    return results;
  }
}

class StoreItemSize {
  final String size;
  const StoreItemSize(this.size);
}
