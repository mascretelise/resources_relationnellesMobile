import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:photo_view/photo_view.dart';
//import 'package:video_player/video_player.dart';

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
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        items: options
            .map((option) => DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                ))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  static Widget previewFile({
    required String titre,
    required String description,
    required String categorie,
    required String path,
    required String ext,
    required String auteur,
  }) {
    //final ext = path.split('.').last.toLowerCase();
    if (['jpg', 'jpeg', 'png', 'gif'].contains(ext)) {
      return Column(
        children: [
          Text("${titre} de ${auteur}"),
          Text(categorie),
          PhotoView(imageProvider: FileImage(File(path))),
          Text(description),
        ],
      );
    } else if (ext == 'pdf') {
      return Column(
        children: [
          Text("${titre} de ${auteur}"),
          Text(categorie),
          SfPdfViewer.file(File(path)),
          Text(description),
        ],
      );
    }
    // else if (['mp4', 'mov', 'avi'].contains(ext)) {
    //   return VideoPreview(path: path);
    // }
    else {
      return Center(child: Text('Unsupported file type'));
    }
  }
}
