import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myapp/category.dart';
import 'package:myapp/component/ressources_relationelles_elements.dart';
import 'package:myapp/user.dart';
import 'package:provider/provider.dart';

class SearchRessources extends StatefulWidget {
  const SearchRessources({super.key});

  @override
  State<SearchRessources> createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<SearchRessources> {
  final TextEditingController _nomRessourceController = TextEditingController();
  final TextEditingController _typeRessourceController =
      TextEditingController();
  String? _categorieRessourceController;

  @override
  void dispose() {
    _nomRessourceController.dispose();
    super.dispose();
  }

  void showCustomDialog(String texte) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Attention'),
        content: Text(texte),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final List<String> categories =
        categoryProvider.categories.map((cat) => cat.name).toList();
    final user = Provider.of<User>(context, listen: false);
    return SingleChildScrollView(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Row(
                  children: [
                    RessourcesRelationellesElements.buildTextField(
                      label: "Nom",
                      controller: _nomRessourceController,
                      widthPercent: 32,
                      context: context,
                    ),
                    RessourcesRelationellesElements.buildTextField(
                      label: "Type",
                      controller: _typeRessourceController,
                      widthPercent: 32,
                      context: context,
                    ),
                    RessourcesRelationellesElements.buildDropdown(
                      label: "Catégories",
                      options: categories,
                      value: _categorieRessourceController,
                      widthPercent: 32,
                      context: context,
                      onChanged: (newValue) {
                        setState(
                            () => _categorieRessourceController = newValue);
                      },
                    ),
                  ],
                ),
              ),
              FutureBuilder<Widget>(
                  future: buildFilesViewer(user),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(); // Show loading indicator while fetching
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}'); // Error handling
                    } else if (snapshot.hasData) {
                      return snapshot.data!; // Show the data once fetched
                    } else {
                      return Text("No data available");
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

Future<Widget> buildFilesViewer(User user) async {
  String response = await user.getLastRessources();
  List<dynamic> decodedResponse = jsonDecode(response);
  print(decodedResponse);

  if (decodedResponse.isEmpty) {
    return Center(child: Text("Aucune ressources trouvées"));
  }

  List<Widget> resourceWidgets = decodedResponse.map<Widget>((resource) {
    String titreRessource = resource['res_nom'] ?? '';
    String extensionRessource = resource['res_extension'] ?? '';
    String categorieRessource = resource['cat_categorie'] ?? '';
    String auteurRessource = resource['res_auteur'] ?? '';
    String descriptionRessource = resource['res_description'] ?? '';
    String descriptionLien = resource['res_lien'] ?? '';

    return RessourcesRelationellesElements.previewFile(
      titre: titreRessource,
      ext: extensionRessource,
      categorie: categorieRessource,
      auteur: auteurRessource,
      description: descriptionRessource,
      path: descriptionLien,
    );
  }).toList();

  // Return the generated list of widgets in a scrollable view
  return Row(
    children: resourceWidgets,
  );
}
