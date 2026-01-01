class CounterItem {
  String name;
  int value;

  CounterItem({required this.name, this.value = 0});

  Map<String, dynamic> toJson() => {'name': name, 'value': value};

  factory CounterItem.fromJson(Map<String, dynamic> json) {
    return CounterItem(
      name: json['name'],
      value: json['value'],
    );
  }
}