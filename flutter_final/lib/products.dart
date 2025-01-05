import 'package:apicallflutter/add_edit_product.dart';
import 'package:apicallflutter/constants/app_urls.dart';
import 'package:apicallflutter/models/product_model.dart';
import 'package:apicallflutter/services/api_helper.dart';
import 'package:flutter/material.dart';

class ProductListPage extends StatefulWidget {
  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Listing"),
        backgroundColor: Colors.blueAccent,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CreateProductPage()));
        },
        backgroundColor: Colors.red,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: Builder(builder: (context) {
        return FutureBuilder(
            future: getProducts(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  if (snapshot.hasData) {
                    final products = snapshot.data;
                    return ListView.builder(
                      itemCount: products!.length,
                      itemBuilder: (context, index) {
                        final product = products![index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => CreateProductPage(),
                                  settings: RouteSettings(arguments: product)),
                            );
                          },
                          child: Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: ListTile(
                              leading: Image.network(
                                product.imageUrl ?? "",
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                              title: Text(product.name ?? ""),
                              subtitle: Text("Price: ₹${product.price ?? ""}"),
                              trailing: IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  bool isSuccess =
                                      await deleteProduct(product.id!);
                                  if (isSuccess) {
                                    // Handle delete action
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text("Deleted ${product.name}")),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }

                  return Text("Error Occured");
                default:
                  return CircularProgressIndicator();
              }
            });
      }),
    );
  }

  Future<List<ProductModel>> getProducts() async {
    try {
      final List products = await ApiHelper.getCall(AppUrls.getProduct);
      return products.map((e) {
        return ProductModel.fromJson(e);
      }).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<bool> deleteProduct(int id) async {
    try {
      await ApiHelper.deleteCall(AppUrls.deleteProduct(id));
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
