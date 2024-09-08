import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget formField({
  required String hint,
  required Icon icon,
  required TextInputType keyboardTypeUser,
  required TextEditingController controller,
  required String? Function(String?)? validator,
}) {
  return TextFormField(
    autovalidateMode: AutovalidateMode.onUserInteraction,
    keyboardType: keyboardTypeUser,
    controller: controller,
    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    decoration: InputDecoration(
      prefixIcon: icon,
      hintText: hint,
      hintStyle:
          GoogleFonts.firaCode(fontSize: 16, fontWeight: FontWeight.w400),
      filled: true,
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
    ),
    validator: validator,
  );
}

Widget elevatedButton(
    {void Function()? onPressed, IconData? icon, String? text}) {
  return ElevatedButton.icon(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      minimumSize: const Size(180, 60),
      backgroundColor: Colors.teal[800],
    ),
    icon: Icon(icon, color: Colors.black),
    label: Text(
      text ?? '',
      style: const TextStyle(color: Colors.white),
    ),
  );
}

TextStyle styleDetails() => GoogleFonts.montserrat(
      fontSize: 24,
      color: Colors.blueGrey.shade700,
      fontWeight: FontWeight.w500,
    );
