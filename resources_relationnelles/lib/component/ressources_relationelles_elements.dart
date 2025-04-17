import 'package:flutter/material.dart';

/*
  Définition des widgets classiques avec paramètres par défaut 
  > TextField
  > Dropdown

*/

class RessourcesRelationellesElements {
  static Widget buildTextField({
    required String label,
    required TextEditingController controller,
    bool isPassword = false,
    double width = 300,
    double? widthPercent,
    BuildContext? context,
  }) {
    double finalWidth = width;
    if (widthPercent != null && context != null) {
      finalWidth = MediaQuery.of(context).size.width * (widthPercent / 100);
    }

    return SizedBox(
      width: finalWidth,
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: label,
        ),
      ),
    );
  }

  static Widget buildDropdown({
    required String label,
    required List<String> options,
    required String? value,
    required Function(String?) onChanged,
    double width = 300,
    BuildContext? context, //requis pour la largeur en %
    double? widthPercent = 100,
  }) {
    double finalWidth = width;
    if (widthPercent != null && context != null) {
      finalWidth = (MediaQuery.of(context).size.width * (widthPercent / 100));
    }

    return SizedBox(
      width: finalWidth,
      child: DropdownButtonFormField<String>(
        style: const TextStyle(
          fontSize: 11,
          color: Colors.black,
        ),
        value: value,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: label,
        ),
        items: options
            .map((option) => DropdownMenuItem<String>(
                  value: option,
                  child: Text(
                    option,
                    style: const TextStyle(fontSize: 14),
                  ),
                ))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
