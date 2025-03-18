import 'dart:convert';  // For jsonDecode
import 'package:flutter/services.dart';  // For rootBundle to load assets

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

  // Optional: Save settings back to JSON or shared preferences
  Future<void> saveSettings() async {
    // Your saving logic here (e.g., save to shared preferences or update the JSON file)
    print("Saving settings...");
  }
}
