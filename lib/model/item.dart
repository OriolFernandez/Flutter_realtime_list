class Item {
  String id;
  String name;
  int numberToBuy;

  Item({
    this.id,
    this.name,
    this.numberToBuy,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'numberToBuy': numberToBuy,
      };

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map.containsKey('id') ? map['id'] : "",
      name: map.containsKey('name') ? map['name'] : "",
      numberToBuy: map.containsKey('numberToBuy') ? map['numberToBuy'] : "",
    );
  }
}
