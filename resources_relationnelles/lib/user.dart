/*
> Classe User
*/
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myapp/config.dart';

class User {
  var id = -1;
  var nom = "";
  var prenom = "";
  var mail = "";
  var passwordHash = "";
  var status = 0;

  disconnect() {
    //remise des valeurs par défaut
    id = -1;
    nom = "";
    prenom = "";
    mail = "";
    passwordHash = "";
    status = 0;
  }

  authentificate(mail, password) async {
    var client = http.Client(); //Création client HTTP
    try {
      print('Sending request to: ${Config.serverIp}${Config.loginRoute}');
      var response = await client.post(
              Config.connect(Config.registerRoute), //Envoi de la requête (IP dans Config.serverIP)
              body: {
            'email': mail,
            'mdp': password
          }) //Headers pour l'API
          .timeout(
              Config.timeoutValue); //timeout de 10 secondes
      var decodedResponse =
          utf8.decode(response.bodyBytes); //récupération de la réponse
      print(decodedResponse);
      if (response.statusCode != 200) {
        throw Exception(
            "Erreur lors de la création du compte - Erreur ${response.statusCode}");
      }
    } catch (error) {
      rethrow;
    } finally {
      client.close();
    }
  }

  register(String nom, String prenom, String mail, String password) async {
    var client = http.Client(); //Création client HTTP
    final url = Uri.parse("${Config.serverIp}${Config.registerRoute}");
    final body = jsonEncode(
        {'lastName': nom, 'firstName': prenom, 'email': mail, 'mdp': password});
    final timeout = Config.timeoutValue;
    final header = {'Content-Type': 'application/json'};

    print("Sending HTTP Request:");
    print("- URL: $url");
    print("- Method: POST");
    print("- Body: $body");
    print("- Timout : $timeout");

    try {
      //Envoi de la requête (IP dans Config.serverIP)
      var response =
          await client.post(Config.connect(Config.registerRoute), 
          body: body, 
          headers: header).timeout(timeout);

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
