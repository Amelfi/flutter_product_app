import 'dart:io';

import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  final String? picture;
  const ProductImage({super.key, this.picture});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, top: 10, left: 10),
      child: Container(
        width: double.infinity,
        height: 450,
        decoration: _buildBoxDecoration(),
        child: Opacity(
          opacity: 0.9,
          child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(45), topRight: Radius.circular(45)),
              child: getImage(picture)),
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() {
    return BoxDecoration(
        borderRadius: const BorderRadius.only(
            topRight: Radius.circular(45), topLeft: Radius.circular(45)),
        color: Colors.black,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 10,
              offset: const Offset(0, 5))
        ]);
  }
}

Widget getImage(String? picture) {
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
