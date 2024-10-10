class Product {
  String id;
  String name;
  double price;

  Product({required this.id, required this.name, required this.price});

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'price': price,
  };

  static Product fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(), // Ensure price is a double
    );
  }
}
