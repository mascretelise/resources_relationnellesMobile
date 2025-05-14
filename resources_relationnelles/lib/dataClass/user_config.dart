import 'dart:convert'; // For jsonDecode
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/dataClass/themeProvider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart'; // For rootBundle to load assets

class UserConfig {
  // Instance variables with default values
  bool rememberUsername = false; // Default to true
  String username = ""; // Default empty
  bool nightMode = false; // Default to false
  bool colorblind = false; // Default to true
  String colorblindType = ""; // Default empty

  // Constructor to load settings from the JSON file on instantiation
  UserConfig(context) {
    loadFromJson(context);
  }

Future<void> loadFromJson(BuildContext context) async {
  final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
  try {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/settings.json';
    final File file = File(filePath);

    if (await file.exists()) {
      final String jsonString = await file.readAsString();
      final Map<String, dynamic> data = jsonDecode(jsonString);

      rememberUsername = data['storeUsername'] ?? rememberUsername;
      nightMode = data['enableNightmode'] ?? nightMode;
      colorblind = data['colorblindMode'] ?? colorblind;
      colorblindType = data['colorblindType'] ?? colorblindType;

      themeProvider.setThemeFromBool(nightMode); // Apply theme from file

      print("LOADED SETTINGS:");
      print("Remember Username: $rememberUsername");
      print("Night Mode: $nightMode");
      print("Colorblind Mode: $colorblind");
      print("Colorblind Type: $colorblindType");
    } else {
      print("No saved settings file found.");
    }
  } catch (e) {
    print("Error loading settings: $e");
  }
}


  Future<void> saveSettings(context) async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    print("Saving settings...");
    try {
      // Récupération du fichier de config
      final Directory directory = await getApplicationDocumentsDirectory();
      final String filePath = '${directory.path}/settings.json';
      final File file = File(filePath);

      print("Settings file path: $filePath");

      Map<String, dynamic> existingSettings = {};

      // Lire le fichier si il existe déjà
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        existingSettings = jsonDecode(jsonString);
      }

      // Mise à jour des paramètres existants avec les nouvelles valeurs
      existingSettings.addAll({
        'storeUsername': rememberUsername,
        'enableNightmode': themeProvider.isDarkMode,
        'colorblindMode': colorblind,
        //'colorblindType': colorblindType,
      });

      // Conversion en JSON
      final jsonString = jsonEncode(existingSettings);

      // Écriture dans le fichier
      await file.writeAsString(jsonString);
      print("Settings saved to JSON file.\n $jsonString");
      loadFromJson(context);
    } catch (e) {
      print("Error saving settings: $e");
    }
  }
}
