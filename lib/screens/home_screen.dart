import 'package:flutter/material.dart';
import 'package:flutter_products_app/models/product.dart';
import 'package:flutter_products_app/screens/screens.dart';
import 'package:flutter_products_app/services/services.dart';
import 'package:flutter_products_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsService = Provider.of<ProductsService>(context);

    if (productsService.isLoading) return const LoadingScreen();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
      ),
      body: ListView.builder(
        itemCount: productsService.products.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
              onTap: () {
                productsService.selectedProduct =
                    productsService.products[index].copy();
                Navigator.pushNamed(context, 'product',
                    arguments: productsService.selectedProduct);
              },
              child: ProductCard(products: productsService.products[index]));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          productsService.selectedProduct = Product(available: false, name: '', price: 0.0);
          Navigator.pushNamed(
            context, 'product',
            arguments: productsService.selectedProduct);
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
