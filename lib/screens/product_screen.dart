import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_products_app/models/product.dart';
import 'package:flutter_products_app/providers/product_form_provider.dart';
import 'package:flutter_products_app/services/products_service.dart';
import 'package:flutter_products_app/ui/input_decorations.dart';
import 'package:flutter_products_app/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dynamic receivedArgs = ModalRoute.of(context)!.settings.arguments;
    final Product product = receivedArgs;
    final productService = Provider.of<ProductsService>(context);
    return ChangeNotifierProvider(
      create: (_) => ProductFormProvider(product),
      child: _ProductScreenBody(productService: productService),
    );
  }
}

class _ProductScreenBody extends StatelessWidget {
  final ProductsService productService;

  const _ProductScreenBody({required this.productService});
  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);
    final product = productForm.product;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                ProductImage(picture: productService.selectedProduct.picture),
                Positioned(
                    top: 40,
                    left: 7,
                    child: IconButton(
                        iconSize: 40,
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back_ios_new_outlined,
                          color: Colors.white,
                        ))),
                Positioned(
                    top: 40,
                    right: 7,
                    child: IconButton(
                        iconSize: 40,
                        onPressed: () async {
                          //Todo Camara o galeria
                          final picker = ImagePicker();
                          final XFile? pickedFile = await picker.pickImage(
                              source: ImageSource.gallery);
                          if (pickedFile == null) {
                            print('No selecciono nada');
                            return;
                          }
                          productService
                              .updateSelectedProductImage(pickedFile.path);
                          // product.picture = pickedFile.path;
                          print('Tenemos imagen ${pickedFile.path}');
                        },
                        icon: const Icon(Icons.camera_alt_outlined,
                            color: Colors.white))),
              ],
            ),
            const _ProductForm(),
            const SizedBox(
              height: 100,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        backgroundColor: Colors.indigo,
        onPressed: productService.isLoading
        ? null
        : () async {
          if (!productForm.isValidForm()) return;
          final String? imageUrl = await productService.uploadImage();
          if (imageUrl != null) product.picture = imageUrl;
          await productService.saveOrUpdateProducts(product);
        },
        child: productService.isSaving
        ? const CircularProgressIndicator(color: Colors.white,)
        : const Icon(
          Icons.save_outlined,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _ProductForm extends StatelessWidget {
  // final Product? product;
  const _ProductForm();

  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);
    final product = productForm.product;
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  offset: const Offset(0, 0.5),
                  blurRadius: 10)
            ]),
        child: Form(
          key: productForm.formKey,
          child: Column(
            children: [
              const SizedBox(height: 15),
              TextFormField(
                initialValue: product.name,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: (value) => product.name = value,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'El nombre es requerido';
                  return null;
                },
                decoration: InputDecorations.authInputDecoration(
                    hintText: 'Nombre del producto', labelText: 'Nombre:'),
              ),
              const SizedBox(height: 25),
              TextFormField(
                initialValue: '${product.price}',
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^(\d+)?\.?\d{0,2}'))
                ],
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  double.tryParse(value) == null
                      ? product.price = 0
                      : product.price = double.parse(value);
                },
                decoration: InputDecorations.authInputDecoration(
                    hintText: '\$99.99', labelText: 'Precio:'),
              ),
              const SizedBox(height: 25),
              SwitchListTile.adaptive(
                  title: const Text('Disponible?'),
                  activeColor: Colors.indigo,
                  value: product.available,
                  onChanged: productForm.isAvailable),
              const SizedBox(height: 25)
            ],
          ),
        ),
      ),
    );
  }
}
