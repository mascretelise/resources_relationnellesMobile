import 'package:flutter/material.dart';
import 'package:myapp/component/ressources_relationelles_elements.dart';

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
                      options: ["Astronomie", "Nourriture", "Chats"],
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
            ],
          ),
        ),
      ),
    );
  }
}
