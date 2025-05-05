import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:myapp/category.dart';
import 'package:myapp/component/ressources_relationelles_elements.dart';
import 'package:myapp/config.dart';
import 'package:myapp/user.dart';
import 'package:provider/provider.dart';

class ExportRessource extends StatefulWidget {
  const ExportRessource({super.key});

  @override
  _ExportRessourceState createState() => _ExportRessourceState();
}

class _ExportRessourceState extends State<ExportRessource> {
  final TextEditingController _titreRessourceController =
      TextEditingController();
  final TextEditingController _descriptionRessourceController =
      TextEditingController();
  String? _categorieRessourceController;

  String? _fileName; // Variable to store the selected file's name
  bool champsRemplis = false;
  Uint8List? fileData;
  String? fileExtension;

  // Function to pick a file
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      // Get the first file from the result
      PlatformFile file = result.files.first;
      File selectedFile = File(file.path!);
      Uint8List data = await selectedFile.readAsBytes();

      setState(() {
        fileData = data;
        fileExtension = file.extension;
        _fileName = file.name; // Update the file name in the state
      });

      // You can also access the file's path or bytes if you need to upload it.
      // Example: print('File path: ${file.path}');
    } else {
      print("No file selected.");
    }
    checkInputs();
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final List<String> categories =
        categoryProvider.categories.map((cat) => cat.name).toList();

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              height: 500,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Ajouter une ressource :",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16),
                      RessourcesRelationellesElements.buildTextField(
                        label: "Titre :",
                        controller: _titreRessourceController,
                        context: context,
                        width: 300,
                      ),
                      SizedBox(height: 16),
                      RessourcesRelationellesElements.buildDropdown(
                        label: "Catégorie",
                        options: categories,
                        widthPercent: 76,
                        width: 300,
                        value: _categorieRessourceController,
                        context: context,
                        onChanged: (newValue) {
                          setState(
                              () => _categorieRessourceController = newValue);
                        },
                      ),
                      SizedBox(height: 16),
                      RessourcesRelationellesElements.buildTextField(
                        label: "Description :",
                        controller: _descriptionRessourceController,
                        context: context,
                        width: 300,
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _pickFile,
                        child: Text("Choisir un fichier"),
                      ),
                      SizedBox(height: 16),
                      if (_fileName == null)
                        Text(
                          "Aucun fichier sélectionné",
                          style: TextStyle(fontSize: 16),
                        )
                      else
                        Text(
                          "Fichier sélectionné: $_fileName",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      Spacer(),
                      ElevatedButton(
                        onPressed: champsRemplis ? sendRessource : null,
                        child: Text("Enregistrer la ressource"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titreRessourceController.dispose();
    _descriptionRessourceController.dispose();
    super.dispose();
  }

  Widget buildTextField(String label, TextEditingController controller,
      {bool isPassword = false}) {
    return SizedBox(
      width: 300,
      height: 50,
      child: TextField(
        onChanged: (_) => checkInputs(),
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: label,
        ),
      ),
    );
  }

  checkInputs() {
    setState(() {
      champsRemplis = _titreRessourceController.text.isNotEmpty &&
          _categorieRessourceController != null &&
          _descriptionRessourceController.text.isNotEmpty &&
          _fileName != null &&
          fileData != null;
    });
  }

  Future<void> sendRessource() async {
    final user = Provider.of<User>(context, listen: false);
    var client = http.Client(); // Client HTTP
    try {
      var uri = Config.connect(Config.uploadRoute); // Composition URL pour API
      var request = http.MultipartRequest('POST', uri); // POST method
      request.fields.addAll({
        'res_nom': _titreRessourceController.text,
        'cat_categorie': _categorieRessourceController!,
        'res_description': _descriptionRessourceController.text,
        'res_extension': fileExtension!,
        'com_commentaire': "yuumi",
      });

      //Ajout du fichier dans la requêtes
      if (_fileName != null && fileData != null) {
        request.files.add(http.MultipartFile.fromBytes(
          'fileData',
          fileData!,
          filename: _fileName!,
        ));
      }

      request.headers['authorization'] =
          'Bearer ${user.token}'; //le renvoie dans le header avec authorization

      debugPrint("---- Détails de la requête ----");
      debugPrint("Titre : ${_titreRessourceController.text}");
      debugPrint("Catégorie : ${_categorieRessourceController!}");
      debugPrint("Description : ${_descriptionRessourceController.text}");
      debugPrint("Fichier : $_fileName ($fileExtension)");
      debugPrint("Taille : ${fileData!.length} octets");
      debugPrint("Token : ${user.token}");
      debugPrint("Headers : ${request.headers}");
      debugPrint("Champs : ${request.fields}");
      debugPrint("Fichiers : ${request.files.length}");
      debugPrint("------------------------------");

      // Send the request
      var response = await request.send().timeout(Duration(seconds: 10));

      // Read and decode the response
      var decodedResponse = await response.stream.bytesToString();
      print(decodedResponse);
    } catch (error) {
      print("Error: $error");
    } finally {
      // Close the client
      client.close();
    }
  }
}
