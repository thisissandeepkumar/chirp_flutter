import 'package:flutter/material.dart';

Widget commsTextField(
    {required TextEditingController controller,
    required String label,
    bool isObscure = false}) {
  return TextFormField(
    controller: controller,
    obscureText: isObscure,
    decoration: InputDecoration(
      border: const OutlineInputBorder(),
      labelText: label,
    ),
  );
}
