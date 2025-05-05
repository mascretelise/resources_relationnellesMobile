import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/config.dart';

class Category {
  int id;
  String name;
  String? description;
  int vues;

  Category(
      {required this.id,
      required this.name,
      required this.description,
      required this.vues});
}

class CategoryProvider with ChangeNotifier {
  final List<Category> _categories = [];

  List<Category> get categories => [..._categories];

  void addCategory(Category category) {
    _categories.add(category);
    notifyListeners();
  }

  void removeCategory(String id) {
    _categories.removeWhere((cat) => cat.id == id);
    notifyListeners();
  }

  void clearCategories() {
    _categories.clear();
    notifyListeners();
  }

  void getCategory() async {
    var client = http.Client(); //Création client HTTP
    try {
      final Uri url = Config.connect(Config.recuperationCategories);
      var response = await client.get(url).timeout(Config.timeoutValue);
      var decodedResponse = utf8.decode(response.bodyBytes);
      print(decodedResponse);
      if (response.statusCode != 200) {
        throw Exception(
            "Erreur lors de la récupération des ressources : ${response.statusCode}");
      } else {
        final List<dynamic> data = jsonDecode(decodedResponse);
        _categories.clear(); // Optional: clear existing before adding new
        _categories.addAll(
          data.map((json) => Category(
                id: json['cat_ucid'],
                name: json['cat_nom'],
                description: json['cat_description'],
                vues: json['cat_vues'],
              )),
        );
      }
    } catch (error) {
      rethrow;
    } finally {
      client.close();
    }
    notifyListeners();
  }
}
