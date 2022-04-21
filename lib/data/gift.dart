class Gift {
  String id;
  String name;
  double price;
  _Store store;

  Gift(this.id, this.name, this.price, this.store);

  static Gift create() {
    return Gift('', '', 0.0, _Store.empty());
  }

  static Gift fromJson(Map<String, dynamic> map) {
    return Gift(
        map['_id'], map['name'], map['price'], _Store.fromJson(map['store']));
  }

  Map<String, dynamic> toJson() => {'name': name, 'price': price};

  static List<Gift> toList(List<dynamic> list) {
    return list.map((element) => fromJson(element)).toList();
  }
}

class _Store {
  String name;
  String? url;
  _Store(this.name, [this.url]);

  static _Store empty() {
    return _Store('');
  }

  static _Store fromJson(Map<String, dynamic> map) {
    return _Store(map['name'], map['productURL']);
  }
}
