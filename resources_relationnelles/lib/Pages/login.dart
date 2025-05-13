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
                    onLoginSuccess: (email) {
                      Navigator.pushReplacementNamed(context, '/user');
                    },
                    onLoginError: (error) {
                      debugPrint("Erreur login: $error");
                    },
                  )
                : RegisterWidget(
                    onRegisterSuccess: (email) {
                      Navigator.pushReplacementNamed(context, '/user');
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
}
