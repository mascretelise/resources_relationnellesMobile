/*
> Classe User
*/
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:myapp/dataClass/config.dart';

class User extends ChangeNotifier {
  var id = -1;
  var nom = "";
  var prenom = "";
  var mail = "";
  var passwordHash = "";
  var status = 0;
  var pseudonyme = "";
  late String token;
  //late PersistCookieJar cookieJar;

  User._(); // private named constructor

  static Future<User> create() async {
    final user = User._();
    // final directory = await getApplicationDocumentsDirectory();
    // user.cookieJar = PersistCookieJar(
    //   storage: FileStorage('${directory.path}/.cookies/'),
    //   ignoreExpires: false,
    //   persistSession: true,
    // );
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
    pseudonyme = "";
    //cookieJar.deleteAll();
  }

  Future<void> authentificate(String mail, String password) async {
    var client = http.Client(); //Création client HTTP
    try {
      final Uri urlLogin = Config.connect(Config.loginRoute);
      var responseLogin = await client.post(urlLogin, body: {
        'email': mail,
        'mdp': password,
      }).timeout(
          Config.timeoutValue); //paramètres de la requête (url, données, TO)

      var decodedResponseLogin = utf8.decode(responseLogin.bodyBytes);
      print(decodedResponseLogin);
      print(responseLogin.headers);

      if (responseLogin.statusCode != 200) {
        throw Exception(
            "Erreur lors de l'authentification' ${responseLogin.statusCode}");
      } else {
        token = responseLogin.headers['token']!;
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
      'mdp': password,
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
        case 200:
          break;
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

  Future<void> getInfos() async {
    var client = http.Client();

    final Uri urlGetInfos = Config.connect(
      "/user/infosByEmail",
      queryParams: {'email': mail}, // Proper query handling
    );

    try {
      var responseGetInfos = await client.get(
        urlGetInfos,
        headers: {'token': token},
      );

      var decodedResponseGetInfos = utf8.decode(responseGetInfos.bodyBytes);
      print(decodedResponseGetInfos);
      print(responseGetInfos.headers);

      if (responseGetInfos.statusCode != 200) {
        throw Exception(
          "Erreur lors de la récupération des données utilisateur, code ${responseGetInfos.statusCode}",
        );
      }
      List<dynamic> userList = jsonDecode(decodedResponseGetInfos);
      Map<String, dynamic> user = userList[0];

      mail = user['uti_email'];
      prenom = user['uti_name'];
      nom = user['uti_firstname'];
      status = user['uti_statut'];
      pseudonyme = user['uti_pseudonyme']??""; // nullable
      passwordHash = user['uti_password'];

      print(userList);
    } catch (e) {
      print("Erreur dans getInfos: $e");
      rethrow;
    } finally {
      client.close();
    }
  }

  Future<String> getLastRessources() async {
    var client = http.Client(); //Création client HTTP
    try {
      final Uri url = Config.connect(Config.lastRessources);
      var response = await client.get(url).timeout(Config.timeoutValue);
      var decodedResponse = utf8.decode(response.bodyBytes);
      print(decodedResponse);
      if (response.statusCode != 200) {
        throw Exception(
            "Erreur lors de la récupération des ressources : ${response.statusCode}");
      } else {
        return decodedResponse;
      }
    } catch (error) {
      rethrow;
    } finally {
      client.close();
    }
  }
}
