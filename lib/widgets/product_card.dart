import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_products_app/models/models.dart';

class ProductCard extends StatelessWidget {
  final Product products;
  const ProductCard({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        height: 350,
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 20, top: 20),
        decoration: _cardBorders(),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            _BackgroundImage(products: products),
            _ProductDetails(products: products),
            Positioned(top: 0, right: 0, child: _PriceTag(products: products)),
            if (!products.available)
              const Positioned(top: 0, left: 0, child: _NotAvailable())
          ],
        ),
      ),
    );
  }

  BoxDecoration _cardBorders() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(25),
      boxShadow: const [
        BoxShadow(color: Colors.black12, offset: Offset(0, 7), blurRadius: 10)
      ],
      color: Colors.white,
    );
  }
}

class _NotAvailable extends StatelessWidget {
  const _NotAvailable();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: 100,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.yellow[800],
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25), bottomRight: Radius.circular(25))),
      child: const FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'No disponible',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _PriceTag extends StatelessWidget {
  final Product products;
  const _PriceTag({required this.products});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: 100,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
          color: Colors.indigo,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(25), bottomLeft: Radius.circular(25))),
      child: FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            '\$${products.price}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _ProductDetails extends StatelessWidget {
  final Product products;
  const _ProductDetails({required this.products});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 50),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        height: 70,
        width: double.infinity,
        decoration: _buildBoxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              products.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              products.id ?? '#',
              style: const TextStyle(color: Colors.white, fontSize: 15),
            )
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => const BoxDecoration(
      color: Colors.indigo,
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25), topRight: Radius.circular(25)));
}

class _BackgroundImage extends StatelessWidget {
  final Product products;
  const _BackgroundImage({required this.products});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Container(
        width: double.infinity,
        height: 350,
        // color: Colors.red,
        child: getImageProduct(products.picture),
      ),
    );
  }
}

Widget getImageProduct(String? picture) {
  if (picture == null) {
    return const Image(image: AssetImage('assets/no-image.png'), fit: BoxFit.cover);
  }

  if (picture.startsWith('http')) {
    return FadeInImage(
      placeholder: const AssetImage('assets/jar-loading.gif'),
      image: NetworkImage(picture),
      fit: BoxFit.cover,
    );
  }

  return Image.file(
    File(picture),
    fit: BoxFit.cover,
  );
}