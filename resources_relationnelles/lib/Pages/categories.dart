import 'package:flutter/material.dart';
import 'package:myapp/dataClass/category.dart';
import 'package:provider/provider.dart';
import 'package:myapp/dataClass/config.dart';
import 'package:myapp/dataClass/user.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Categories")),
      body: categoryProvider.categories.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              scrollDirection:
                  Axis.vertical, // Scroll vertical pour toute la page
              child: SingleChildScrollView(
                scrollDirection:
                    Axis.horizontal, // Scroll horizontal pour la table
                child: Column(
                  children: [
                    DataTable(
                      columns: const [
                        DataColumn(label: Text('ID')),
                        DataColumn(label: Text('Nom')),
                        //DataColumn(label: Text('Description')),
                        DataColumn(label: Text('Éditer')),
                        DataColumn(label: Text('Supprimer')),
                      ],
                      rows: categoryProvider.categories.map((category) {
                        return DataRow(cells: [
                          DataCell(Text(category.id.toString())),
                          DataCell(Text(category.name)),
                          // DataCell(
                          //   TextButton(
                          //     child: const Text('Description'),
                          //     onPressed: () =>
                          //         showDescription(context, category),
                          //   ),
                          // ),
                          DataCell(
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                editCategory(context, category);
                              },
                            ),
                          ),
                          DataCell(
                            IconButton(
                              icon: const Icon(Icons.delete),
                              color: Colors.red,
                              onPressed: () {
                                print(category.id);
                              },
                            ),
                          ),
                        ]);
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddCategoryDialog(context);
        },
        child: const Icon(Icons.add),
        tooltip: 'Ajouter une catégorie',
      ),
    );
  }

  void showDescription(BuildContext context, Category category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Catégorie ${category.name}'),
        content: Text(category.description ?? 'Aucune description.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void editCategory(BuildContext context, Category category) {
    final TextEditingController nameController =
        TextEditingController(text: category.name);
    // final TextEditingController descriptionController =
    //     TextEditingController(text: category.description);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Éditer la catégorie'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nom'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              updateCategory(category.id, nameController.text);
              Navigator.of(context).pop();
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }

  Future<void> updateCategory(int id, String newName) async {
    var client = http.Client();

    final Uri updateCategoryUri = Config.connect(
      Config.editionCategories,
      queryParams: {'id': '$id'},
    );

    try {
      var response = await client.post(
        updateCategoryUri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': newName}),
      );

      var decodedResponse = utf8.decode(response.bodyBytes);
      print('Réponse API : $decodedResponse');

      if (response.statusCode != 200) {
        throw Exception(
            "Erreur lors de la mise à jour : code ${response.statusCode}");
      }

      // Appel au provider pour mettre à jour
      Provider.of<CategoryProvider>(context, listen: false).updateCategory(
        id,
        newName,
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Erreur'),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      client.close();
    }
  }

  void _showAddCategoryDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajouter une catégorie'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Nom de la catégorie'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              final newCategoryName = nameController.text.trim();
              if (newCategoryName.isNotEmpty) {
                _addCategory(context,
                    newCategoryName); // Fonction pour ajouter la catégorie
                Navigator.of(context).pop();
              } else {
                // Vous pouvez ajouter une alerte si le champ est vide
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content:
                          Text('Le nom de la catégorie ne peut pas être vide')),
                );
              }
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }

  Future<void> _addCategory(BuildContext context, String newName) async {
    var client = http.Client(); // Création du client HTTP

    final body = jsonEncode({
      'category': newName, // Le nom de la nouvelle catégorie
    });

    final header = {'Content-Type': 'application/json'};

    print("Sending HTTP Request:");
    print("- Method: POST");
    print("- Body: $body");

    try {
      // Envoi de la requête POST pour ajouter la catégorie
      var response = await client
          .post(Config.connect(Config.ajoutCategorie),
              body: body, headers: header)
          .timeout(Config.timeoutValue); // Timeout configuré

      // Récupération de la réponse
      var decodedResponse = utf8.decode(response.bodyBytes);
      print(decodedResponse);

      switch (response.statusCode) {
        case 200:
        case 201:
          Provider.of<CategoryProvider>(context, listen: false)
              .getCategory();
          print("Catégorie créée avec succès !");
          break;
        case 404:
          // API non trouvée
          throw Exception("Api non trouvée - Erreur ${response.statusCode}");
        case 500:
          // Erreur serveur interne
          throw Exception(
              "Erreur interne au serveur - Erreur ${response.statusCode}");
        default:
          // Autre code d'erreur
          throw Exception("Erreur ${response.statusCode}");
      }
    } catch (error) {
      //ajouterModal error
      print(error);
    } finally {
      client.close(); // Fermer la connexion du client
    }
  }
}
