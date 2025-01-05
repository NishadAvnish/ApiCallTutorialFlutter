class ProductReqmodel {
  String? name;
  double? price;
  String? imageUrl;

  ProductReqmodel({this.name, this.price, this.imageUrl});

  ProductReqmodel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    price = json['price'];
    imageUrl = json['imageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = name;
    data['price'] = price?.toString();
    data['imageUrl'] = imageUrl;
    return data;
  }
}
