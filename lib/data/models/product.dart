class Product{
  int id;
  String title;
  String description;
  int price;
  int stock;
  String thumbnail;
  bool isInDb;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.stock,
    required this.thumbnail,
    required this.isInDb
  });

  Product.fronJson(Map<String, dynamic> json)
  : this (
    id: json['id'],
    title: json['title'],
    description: json['description'],
    price: json['price'],
    stock: json['stock'],
    thumbnail: json['thumbnail'],
    isInDb: false
    );


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'stock': stock,
      'thumbnail': thumbnail,
      'is_in': 1
    };
  }

  Product.fromMap(Map<String, dynamic> map)
  : this(
    id: map['id'],
    title: map['title'],
    description: map['description'],
    price: map['price'],
    stock: map['stock'],
    thumbnail: map['thumbnail'],
    isInDb: map['is_in'] == 1
  );

}