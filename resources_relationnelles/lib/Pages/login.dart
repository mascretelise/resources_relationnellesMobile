import 'package:flutter/material.dart';
import 'package:myapp/user.dart';

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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers when the widget is disposed
    _emailController.dispose();
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
    var email = _emailController.text; //Récupération des IDs
    var password = _passwordController.text;

    if (StringEmpty(email) | StringEmpty(password)) {
      messageRemplirLoginEtPassword();
    }

    print(email);
    print(password);
    setState(() {
      buttonLoginEnabled = false; // Disable the button
    });
    try {
      await User().authentificate(email, password);
    } catch (error) {
      //Si erreur connexion
      setState(() {
        buttonLoginEnabled = true; // Disable the button
      });
      print("Erreur requête :");
      print(error);
      showPopupErreurConnexion(context, error);
      return;
    } finally {}
  }

  void showPopupErreurConnexion(BuildContext context, error) {
    //Affichage POPup si erreur connexion
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Erreur'),
          content: Text(
              "L'application a rencontré une erreur et n'a pas pu joindre le serveur \n Veuillez réessayer plus tard. \n $error"),
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
                controller: _emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Adresse mail",
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
