import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:myapp/config.dart';

/*
> Page d'authentification pour l'appli mobile
> Demande login + mot de passe
> Envoi de la requête à un serveur 

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
  var buttonLoginEnabled = true;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers when the widget is disposed
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool StringEmpty(value) {
    return (value == "");
  }

  void messageRemplirLoginEtPassword() {
    setState(() {
      buttonLoginEnabled = true; // Disable the button
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Attention'),
          content: Text(
              "Veuillez remplir votre nom d'utilisateur ainsi que votre mot de passe afin de vous connecter."),
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

  void login(BuildContext context) async {
    var username = _usernameController.text; //Récupération des IDs
    var password = _passwordController.text;

    if (StringEmpty(username) | StringEmpty(password)) {
      messageRemplirLoginEtPassword();
    }

    print(username);
    print(password);
    var client = http.Client(); //Création client HTTP
    setState(() {
      buttonLoginEnabled = false; // Disable the button
    });
    try {
      var response = await client.post(
          Uri.http(
              Config.serverIp), //Envoi de la requête (IP dans Config.serverIP)
          headers: {
            'username': username,
            'password': password
          }); //Headers pour l'API
      var decodedResponse =
          utf8.decode(response.bodyBytes); //récupération de la réponse
      print(decodedResponse);
    } catch (error) {
      //Si erreur connexion
      setState(() {
        buttonLoginEnabled = true; // Disable the button
      });
      print("Erreur requête :");
      print(error);
      showPopupErreurConnexion(context);
    } finally {
      //Fermeture du client
      client.close();
      //Traitement de la réponse
    }
  }

  void showPopupErreurConnexion(BuildContext context) {
    //Affichage POPup si erreur connexion
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
                onPressed: buttonLoginEnabled
                    ? () => {
                          print('Bouton désactivé'),
                          login(context),
                        }
                    : null, // Only call login if enabled
                style: OutlinedButton.styleFrom(
                  foregroundColor: buttonLoginEnabled
                      ? Color.fromRGBO(181, 137, 194, 1)
                      : Color.fromRGBO(0, 0, 0, 1),
                  side: BorderSide(
                    color: buttonLoginEnabled
                        ? Color.fromRGBO(224, 224, 224, 1)
                        : Color.fromRGBO(64, 64, 64, 1),
                  ),
                  backgroundColor: buttonLoginEnabled
                      ? Color.fromRGBO(255, 255, 255, 1)
                      : Color.fromRGBO(128, 128, 128, 1),
                ),
                child: Text(
                  buttonLoginEnabled ? 'Se connecter' : 'Connexion en cours...',
                ))
          ],
        ),
      ),
    );
  }
}
