class Item {
  String id;
  String name;
  int numberToBuy;

  Item({
    this.id,
    this.name,
    this.numberToBuy,
  });

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map.containsKey('id') ? map['id'] : "",
      name: map.containsKey('name') ? map['name'] : "",
      numberToBuy: map.containsKey('numberToBuy') ? map['numberToBuy'] : "",
    );
  }
}
