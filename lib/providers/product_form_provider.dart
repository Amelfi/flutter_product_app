import 'package:flutter/material.dart';
import 'package:flutter_products_app/models/models.dart';

class ProductFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey();
  Product product;
  ProductFormProvider(this.product);

  isAvailable(value) {
    product.available = value;
    notifyListeners();
  }

  bool isValidForm() {
    print(product.name);
    print(product.price);
    print(product.available);
    return formKey.currentState?.validate() ?? false;
  }
}
