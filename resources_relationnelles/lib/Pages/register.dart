import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:myapp/config.dart';

/*
> Page de création de compte pour l'appli mobile
> Demande : Nom, prénom, adresse mail, mot de passe + confirmation
> Vérification des informations
> Prérequis pour le mot de passe 
    - 10 caractères 
    - Une majuscule
    - Une minuscule
    - Un chiffre
    - Un caractère spécial
> Envoi d'un message si informations incorrectes

> Envoi de la requête à un serveur 


Idées d'amélioration:
> Sécurité  : Mettre en place une clé API pour la communication avec le serveur
> Affichage : Rendre l'interface un peu plus jolie
*/

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Register> {
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  var buttonLoginEnabled = true;

  @override
  void dispose() {
    // Dispose controllers when the widget is disposed
    _nomController.dispose();
    _passwordController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  showDialogRegister(texte) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Attention'),
          content: Text(texte),
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

  bool verifierDonneesUtilisateur(String nom, String prenom, String email,
      String password, String confirmPassword) {
    //on part du principe que les infos sont correctes
    var retourData = true;
    var retourPass = true;
    var messageDialog = "Veuillez remplir les champs suivants :\n";
    var passwordDialog = "Votre mot de passe doit contenir au moins : \n";

    // Vérifie chaque champ et ajoute les informations manquantes au message

    //Vérification si le nom est inséré
    if (nom.isEmpty) {
      messageDialog += "- Nom\n";
      retourData = false;
    }
    //Vérification si le prénom est inséré
    if (prenom.isEmpty) {
      messageDialog += "- Prénom\n";
      retourData = false;
    }

    //Vérification si l'adresse mail est insérée
    if (email.isEmpty) {
      messageDialog += "- Email\n";
      retourData = false;
    }

    //Vérification si le mot de passe est inséré
    if (password.isEmpty) {
      messageDialog += "- Mot de passe\n";
      retourData = false;
    }

    //Vérification si le mot de passe est confirmé
    if (confirmPassword.isEmpty) {
      messageDialog += "- Veuillez confirmer votre mot de passe\n";
      retourData = false;
    }

    //Vérification du pattern de l'adresse mail
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      retourData
          ? messageDialog = "L'adresse mail entrée n'est pas valide."
          : messageDialog += "\n L'adresse mail entrée n'est pas valide.";
      retourData = false;
    }

    //Vérification si le mot de passe contient 10 caractères
    if (password.length < 10) {
      passwordDialog += "- 10 caractères \n";
    }

    //Vérification si le mot de passe contient une majuscule
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      passwordDialog += "- Une majuscule\n";
      retourPass = false;
    }

    //Vérification si le mot de passe contient une majuscule
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      passwordDialog += "- Une minuscule\n";
      retourPass = false;
    }

    //Vérification si le mot de passe contient un chiffre
    if (!RegExp(r'\d').hasMatch(password)) {
      passwordDialog += "- Un chiffre\n";
      retourPass = false;
    }

    //Vérification si le mot de passe contient un caractère spécial
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      passwordDialog += "- Un caractère spécial \n";
      retourPass = false;
    }

    //Vérification si les mots de passe sont identiques
    if (password != confirmPassword) {
      retourPass
          ? passwordDialog = "Les mots de passes ne correspondent pas."
          : passwordDialog += "\n Les mots de passes ne correspondent pas.";
      retourPass = false;
    }

    // Affiche les message si nécessaire
    if (!retourData) {
      showDialogRegister(messageDialog);
    }
    if (!retourPass) {
      showDialogRegister(passwordDialog);
    }
    // Retourne true si toutes les données sont valides, sinon false
    return retourPass & retourData;
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

  void register(BuildContext context) async {
    var nom = _nomController.text;
    var prenom = _prenomController.text;
    var email = _emailController.text;
    var password = _passwordController.text;
    var confirmPassword = _confirmPasswordController.text;

    var donneesCompletes = verifierDonneesUtilisateur(
        nom, prenom, email, password, confirmPassword);

    if (!donneesCompletes) {
      //Si a renvoyé false, on n'envoie pas la requête
      return;
    }

    var client = http.Client(); //Création client HTTP
    setState(() {
      buttonLoginEnabled = false; // Disable the button
    });
    try {
      var response = await client.post(
          Uri.http(
              Config.serverIp), //Envoi de la requête (IP dans Config.serverIP)
          headers: {
            'nom': nom,
            'prenom': prenom,
            'email': email,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          // Ensures the content is scrollable
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min, // Keeps the column size compact
                  children: [
                    Text(
                      "S'enregistrer :",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    buildTextField("Nom", _nomController),
                    SizedBox(height: 16),
                    buildTextField("Prénom", _prenomController),
                    SizedBox(height: 16),
                    buildTextField("Adresse mail", _emailController),
                    SizedBox(height: 16),
                    buildTextField("Mot de passe", _passwordController,
                        isPassword: true),
                    SizedBox(height: 16),
                    buildTextField(
                        "Confirmer le mot de passe", _confirmPasswordController,
                        isPassword: true),
                    SizedBox(height: 16),
                    OutlinedButton(
                      onPressed:
                          buttonLoginEnabled ? () => register(context) : null,
                      child: Text(
                        buttonLoginEnabled
                            ? "S'inscrire"
                            : "Création du compte...",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller,
      {bool isPassword = false}) {
    return SizedBox(
      width: 300,
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: label,
        ),
      ),
    );
  }
}
