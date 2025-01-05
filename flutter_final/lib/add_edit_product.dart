import 'package:apicallflutter/constants/app_urls.dart';
import 'package:apicallflutter/models/product_model.dart';
import 'package:apicallflutter/models/product_req_model.dart';
import 'package:apicallflutter/services/api_helper.dart';
import 'package:flutter/material.dart';

class CreateProductPage extends StatefulWidget {
  @override
  _CreateProductPageState createState() => _CreateProductPageState();
}

class _CreateProductPageState extends State<CreateProductPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  ProductModel? productModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    productModel = ModalRoute.of(context)?.settings.arguments as ProductModel;
    if (productModel != null) {
      _nameController.text = productModel?.name ?? "";
      _priceController.text = productModel?.price ?? "";
      _urlController.text = productModel?.imageUrl ?? "";
    }
    super.didChangeDependencies();
  }

  Future<void> _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      String name = _nameController.text;
      double price = double.parse(_priceController.text);
      String url = _urlController.text;
      ProductReqmodel reqModel =
          ProductReqmodel(name: name, price: price, imageUrl: url);
      final bool isSuccess = productModel == null
          ? await addProduct(reqModel)
          : await updateProduct(reqModel, productModel!.id!);
      if (isSuccess) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Product '$name' saved successfully!")),
        );

        // Clear the fields after saving
        _nameController.clear();
        _priceController.clear();
        _urlController.clear();
        Navigator.of(context).pop();
      }
    }
  }

  Future<bool> addProduct(ProductReqmodel reqModel) async {
    try {
      await ApiHelper.postCall(AppUrls.addProduct, body: reqModel.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateProduct(ProductReqmodel reqModel, int id) async {
    try {
      await ApiHelper.putCall(AppUrls.editProduct(id), body: reqModel.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Product"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Product Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the product name";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: "Price (INR)",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the product price";
                  }
                  if (double.tryParse(value) == null) {
                    return "Please enter a valid number";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _urlController,
                decoration: const InputDecoration(
                  labelText: "Image URL",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the image URL";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  _saveProduct();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: const Text(
                  "Save Product",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
