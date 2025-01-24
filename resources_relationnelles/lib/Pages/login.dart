import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crypto/crypto.dart' as crypto;
import 'package:myapp/config.dart';

/*
> Page d'authentification pour l'appli mobile
> Demande login + mot de passe
> Envoi de la requête à un serveur 
> Mot de passe hashé en SHA256

Idées d'amélioration:
> Ergonomie : Stocker les IDs dans un fichier local pour permettre à l'appli de préremplir les champs (utiliser hintText)
> Sécurité  : Mettre en place une clé API pour la communication avec le serveur
> Affichage : Rendre l'interface un peu plus jolie
*/

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Login> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers when the widget is disposed
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void login(BuildContext context) async {
    var username = _usernameController.text;
    var password = _passwordController.text;
    var hashPassword = crypto.sha256.convert(utf8.encode(password)).toString();
    print(password);
    print(hashPassword);
    var client = http.Client();
    try {
      var response = await client.post(Uri.https(Config.serverIp),
          headers: {'login': username, 'password': hashPassword});
      // var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      var decodedResponse = utf8.decode(response.bodyBytes);
      //var uri = Uri.parse(decodedResponse['uri'] as String);
      var uri = Uri.parse(decodedResponse);

      print(await client.get(uri));
    } catch (error) {
      print("Erreur requête :");
      print(error);
      showPopupErreurConnexion(context);
    } finally {
      client.close();
    }
  }

  void showPopupErreurConnexion(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Erreur'),
          content: Text(
              "L'application a rencontré une erreur et n'a pas pu joindre le serveur \n Veuillez réessayer plus tard."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min, // Keeps the widgets centered
          children: [
            Text('Authentification :'),
            SizedBox(height: 16), // Adds spacing between Text and TextField
            SizedBox(
              width: 200, // Optional: set a fixed width for the TextField
              child: TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Nom d'utilisateur",
                ),
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: 200,
              child: TextField(
                controller: _passwordController,
                obscureText: true, // Hides the password for security
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Mot de passe :",
                ),
              ),
            ),
            SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                // Show popup with username and password
                //_showPopup(context);
                login(context);
              },
              child: Text('Se connecter'),
            ),
          ],
        ),
      ),
    );
  }
}
