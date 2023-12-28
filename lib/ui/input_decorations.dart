import 'package:flutter/material.dart';

class InputDecorations {

  static InputDecoration authInputDecoration(
    {
      IconData? icon,
      required String? hintText,
      required String? labelText
    }) {
    return InputDecoration(
        enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.deepPurple)),
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
          color: Colors.deepPurple,
          width: 2,
        )),
        hintText: hintText,
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.grey),
        prefixIcon: icon != null 
        ? Icon(
          icon,
          color: Colors.deepPurple)
        : null);
  }
}
