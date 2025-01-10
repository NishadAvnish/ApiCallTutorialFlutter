class AppUrls {
  AppUrls._();

  static const String baseUrl = "http://192.168.1.6:3000";

  static const String getProduct = "/api/products";
  static const String addProduct = "/api/product";
  static String editProduct(int id) => "/api/product?id=$id";
  static String deleteProduct(int id) => "/api/product?id=$id";
  static const String login = "/api/users/login";
  static const String refreshToken = "/api/generateToken";
}
