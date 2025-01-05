class ProductModel {
  int? id;
  String? name;
  String? price;
  String? imageUrl;

  ProductModel({this.id, this.name, this.price, this.imageUrl});

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price']?.toString();
    imageUrl = json['imageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['price'] = price;
    data['imageUrl'] = imageUrl;
    return data;
  }
}
