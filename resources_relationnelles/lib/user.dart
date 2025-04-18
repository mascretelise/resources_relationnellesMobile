/*
> Classe User
*/
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:myapp/config.dart';

class User extends ChangeNotifier {
  var id = -1;
  var nom = "";
  var prenom = "";
  var mail = "";
  var passwordHash = "";
  var status = 0;
  late String token;
  late PersistCookieJar cookieJar;

  User._(); // private named constructor

  static Future<User> create() async {
    final user = User._();
    final directory = await getApplicationDocumentsDirectory();
    user.cookieJar = PersistCookieJar(
      storage: FileStorage('${directory.path}/.cookies/'),
      ignoreExpires: false,
      persistSession: true,
    );
    return user;
  }

  void updateStatus(int newStatus) {
    status = newStatus;
    notifyListeners();
  }

  void disconnect(context) {
    id = -1;
    nom = "";
    prenom = "";
    mail = "";
    passwordHash = "";
    status = 0;
    token = "";
    cookieJar.deleteAll();
  }

  Future<void> authentificate(String mail, String password) async {
    var client = http.Client(); //Création client HTTP
    try {
      final Uri url = Config.connect(Config.loginRoute);
      var response = await client.post(url, body: {
        'email': mail,
        'mdp': password,
      }).timeout(
          Config.timeoutValue); //paramètres de la requête (url, données, TO)

      var decodedResponse = utf8.decode(response.bodyBytes);
      print(decodedResponse);
      print(response.headers);

      if (response.statusCode != 200) {
        throw Exception(
            "Erreur lors de l'authentification' ${response.statusCode}");
      } else {
        // final cookies =
        //     response.headers['set-cookie']; //Récupération des cookies
        // if (cookies != null) {
        //   cookieJar.saveFromResponse(
        //       url, [Cookie.fromSetCookieValue(cookies)]); //stockage
        //}
        token = response.headers['token']!;
      }
    } catch (error) {
      rethrow;
    } finally {
      client.close();
    }
  }

  register(String nom, String prenom, String mail, String password) async {
    var client = http.Client(); //Création client HTTP
    final body = jsonEncode({
      'lastName': nom,
      'firstName': prenom,
      'email': mail,
      'password': password,
    });

    final header = {'Content-Type': 'application/json'};

    print("Sending HTTP Request:");
    print("- Method: POST");
    print("- Body: $body");

    try {
      //Envoi de la requête (IP dans Config.serverIP)
      var response = await client
          .post(Config.connect(Config.registerRoute),
              body: body, headers: header)
          .timeout(Config.timeoutValue);

      //récupération de la réponse
      var decodedResponse = utf8.decode(response.bodyBytes);
      print(decodedResponse);

      switch (response.statusCode) {
        case 201:
          break;

        case 404:
          throw Exception("Api non trouvée - Erreur ${response.statusCode}");

        case 500:
          throw Exception(
              "Erreur interne au serveur - Erreur ${response.statusCode}");

        default:
          throw Exception("Erreur ${response.statusCode}");
      }
    } catch (error) {
      rethrow;
    } finally {
      client.close();
    }
  }
}
