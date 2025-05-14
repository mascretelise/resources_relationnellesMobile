import 'package:flutter/material.dart';
import 'package:myapp/component/widgetComponents/login_widget.dart';
import 'package:myapp/component/widgetComponents/register_widget.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool typeAuth = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: typeAuth
                ? LoginWidget(
                    onLoginSuccess: (status) {
                      sendToRoute(status);
                    },
                    onLoginError: (error) {
                      debugPrint("Erreur login: $error");
                    },
                  )
                : RegisterWidget(
                    onRegisterSuccess: (status) {
                      sendToRoute(status);
                    },
                    onRegisterError: (error) {
                      debugPrint("Erreur login: $error");
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: toggleAuthType,
              child: Text(
                typeAuth
                    ? "Pas encore inscrit ? Créer un compte"
                    : "Déjà inscrit ? Se connecter",
              ),
            ),
          )
        ],
      ),
    );
  }

  void toggleAuthType() {
    setState(() {
      typeAuth = !typeAuth;
    });
  }

  void sendToRoute(int permission) {
    switch (permission) {
      case 0:
        Navigator.pushReplacementNamed(context, '/disconnected');
        
      case 1:
        Navigator.pushReplacementNamed(context, '/user');

      case 2:
        Navigator.pushReplacementNamed(context, '/user');

      case 3:
        Navigator.pushReplacementNamed(context, '/admin');

      case 4:
        Navigator.pushReplacementNamed(context, '/admin');

      default:
        Navigator.pushReplacementNamed(context, '/user');
    }
  }
}
