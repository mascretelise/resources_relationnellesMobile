import 'dart:convert';  // For jsonDecode
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';  // For rootBundle to load assets

class UserConfig {
  // Instance variables with default values
  bool rememberUsername = false;  // Default to true
  String username = "";         // Default empty
  bool nightMode = false;       // Default to false
  bool colorblind = false;       // Default to true
  String colorblindType = "";   // Default empty

  // Constructor to load settings from the JSON file on instantiation
  UserConfig() {
    loadFromJson();
  }

  // Asynchronously loads settings from JSON file
  Future<void> loadFromJson() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/settings.json');
      final Map<String, dynamic> data = jsonDecode(jsonString);

      // Update instance variables from the loaded data, or use defaults
      rememberUsername = data['storeUsername'] ?? rememberUsername;
      nightMode = data['enableNightmode'] ?? nightMode;
      colorblind = data['colorblindMode'] ?? colorblind;
      colorblindType = data['colorblindType'] ?? colorblindType;

      print("DEFAULTS :");
      print("Remember Username: $rememberUsername");
      print("Night Mode: $nightMode");
      print("Colorblind Mode: $colorblind");
      print("Colorblind Type: $colorblindType");
    } catch (e) {
      print("Error loading JSON: $e");
    }
  }

  Future<void> saveSettings() async {
    print("Saving settings...");
    try {
      //Récupération du fichier de config
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/settings.json');

      // Map avec les données de l'UI
      final Map<String, dynamic> settingsData = {
        'storeUsername': rememberUsername,
        'enableNightmode': nightMode,
        'colorblindMode': colorblind,
        'colorblindType': colorblindType,
      };

      //Conversion en JSON
      final jsonString = jsonEncode(settingsData);

      //Envoi le tout dans le fichier
      await file.writeAsString(jsonString);
      print("Settings saved to JSON file.");
    } catch (e) {
      
      print("Error saving settings: $e");
    }
  }
}
