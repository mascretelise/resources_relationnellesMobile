import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:myapp/config.dart';

class ExportRessource extends StatefulWidget {
  const ExportRessource({super.key});

  @override
  _ExportRessourceState createState() => _ExportRessourceState();
}

class _ExportRessourceState extends State<ExportRessource> {
  final TextEditingController _titreRessourceController = TextEditingController();
  final TextEditingController _descriptionRessourceController = TextEditingController();
  final TextEditingController _categorieRessourceController = TextEditingController();

  String? _fileName;  // Variable to store the selected file's name
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

      fileData = await selectedFile.readAsBytes();
      fileExtension = file.extension;
      setState(() {
        _fileName = file.name;  // Update the file name in the state
      });

      // You can also access the file's path or bytes if you need to upload it.
      // Example: print('File path: ${file.path}');
    } else {
      print("No file selected.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
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
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16),
                      buildTextField("Titre :", _titreRessourceController),

                      SizedBox(height: 16),
                      buildTextField("Catégories :", _categorieRessourceController),

                      SizedBox(height: 16),
                      buildTextField("Description :", _descriptionRessourceController),
                      SizedBox(height: 16),

                      ElevatedButton(
                        onPressed: _pickFile,
                        child: Text("Choisir un fichier"),
                      ),
                      SizedBox(height: 16),
                      // Display selected file name
                      if (_fileName == null) ...[
                        Text(
                          "Aucun fichier sélectionné",
                          style: TextStyle(fontSize: 16),
                        ),
                      ]
                      else ...[
                        Text(
                          "Fichier sélectionné: $_fileName",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ],
                      Spacer(),
                      ElevatedButton(onPressed: champsRemplis? sendRessource : null, child: Text("Enregistrer la ressource"))
                    ],
                  ),
                ),
              ),
            )
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose controllers when the widget is disposed
    _titreRessourceController.dispose();
    _descriptionRessourceController.dispose();
    _categorieRessourceController.dispose();
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

  checkInputs(){
    setState(() {
      champsRemplis = 
        _titreRessourceController.text.isNotEmpty &&
        _categorieRessourceController.text.isNotEmpty &&
        _descriptionRessourceController.text.isNotEmpty &&
        _fileName != null &&
        fileData != null;
    });
  }

  sendRessource() async {
    print("Titre : ${_titreRessourceController.text}");
    print("Catégories : ${_categorieRessourceController.text}");
    print("Description : ${_descriptionRessourceController.text}");
    print("Nom fichier : ${_fileName}");
    print("Extension fichier : ${fileExtension}");
    print("Data fichier: ${fileData}");

    var client = http.Client();//Client HTTP
    try {
      var uri = Config.connect(Config.registerRoute); //Composition URL pour l'api
      var request = http.MultipartRequest('POST', uri); //Méthode POST

      request.fields['title'] = _titreRessourceController.text;
      request.fields['categories'] = _categorieRessourceController.text;
      request.fields['description'] = _descriptionRessourceController.text;
      request.fields['extension'] = fileExtension!;

      // Add file (multipart)
      if (_fileName != null && fileData != null) {
        request.files.add(http.MultipartFile.fromBytes(
          'fileData', // Field name for the file in the form
          fileData!,  // File data as bytes
          filename: _fileName!, // File name
        ));
      }

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