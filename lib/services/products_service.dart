import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_products_app/models/models.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ProductsService extends ChangeNotifier {
  final String _baseUrl = 'flutter-varios-b88bc-default-rtdb.firebaseio.com';

  late List<Product> products = [];
  late Product selectedProduct;
  bool isLoading = true;
  bool isSaving = false;
  final storage = FlutterSecureStorage();

  File? newPictureFile;

  ProductsService() {
    getAllProducts();
  }

  Future<List<Product>> getAllProducts() async {
    isLoading = true;
    notifyListeners();

    final url = Uri.https(
      _baseUrl,
      '/products.json',{
        'auth': await storage.read(key: 'token') ?? ''
      }
    );
    final resp = await http.get(url);
    final Map<String, dynamic> productsMap = json.decode(resp.body);

    productsMap.forEach((key, value) {
      final tempProduct = Product.fromMap(value);
      tempProduct.id = key;
      products.add(tempProduct);
    });

    isLoading = false;
    notifyListeners();

    return products;
  }

  Future saveOrUpdateProducts(Product product) async {
    isSaving = true;
    notifyListeners();

    if (product.id == null) {
      // Crear producto
      await createProduct(product);
    } else {
      //Acturalizar
      await updateProduct(product);
    }

    isSaving = false;
    notifyListeners();
  }

  Future<String> updateProduct(Product product) async {
    final url = Uri.https(
      _baseUrl,
      '/products/${product.id}.json',
      {
        'auth': await storage.read(key: 'token') ?? ''
      }
    );
    final resp = await http.put(url, body: product.toJson());
    final decodedData = resp.body;

    final index = products.indexWhere((element) => element.id == product.id);
    products[index] = product;

    return product.id!;
    // return decodedData;
  }

  Future<String> createProduct(Product product) async {
    final url = Uri.https(
      _baseUrl,
      '/products.json',{
        'auth': await storage.read(key: 'token') ?? ''
      }
    );
    final resp = await http.post(url, body: product.toJson());
    final decodedData = jsonDecode(resp.body);

    product.id = decodedData['name'];

    products.add(product);

    print(decodedData);

    return product.id!;
    // return decodedData;
  }

  void updateSelectedProductImage(String path) {
    selectedProduct.picture = path;
    newPictureFile = File.fromUri(Uri(path: path));
    notifyListeners();
  }

  Future uploadImage() async {
    if (newPictureFile == null) return null;

    isSaving = true;
    notifyListeners();

    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/dtm13pkj8/image/upload?upload_preset=bt8axtqf');

    final imageUploadRequest = http.MultipartRequest('POST', url);
    final file =
        await http.MultipartFile.fromPath('file', newPictureFile!.path);
    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);
    final decodedData = json.decode(resp.body);
    newPictureFile = null;
    return decodedData['secure_url'];

    // final urlCloudinary = respCloudinary.secure_url;

    // product.picture = urlCloudinary.
  }
}
