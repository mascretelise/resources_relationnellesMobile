import 'package:flutter/material.dart';
import 'package:myapp/component/widgetComponents/ressources_relationelles_elements.dart';
import 'package:myapp/dataClass/user.dart';
import 'package:provider/provider.dart';

class LoginWidget extends StatefulWidget {
  final void Function(int status)? onLoginSuccess;
  final void Function(Object error)? onLoginError;

  const LoginWidget({
    super.key,
    this.onLoginSuccess,
    this.onLoginError,
  });

  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  bool buttonLoginEnabled = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _isEmpty(String value) => value.trim().isEmpty;

  void _showAlert(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }

  Future<void> _login() async {
    //final user = Provider.of<User>(context, listen: false);
    final email = _emailController.text;
    final password = _passwordController.text;

    if (_isEmpty(email) || _isEmpty(password)) {
      _showAlert('Attention',
          'Veuillez remplir votre nom d\'utilisateur ainsi que votre mot de passe.');
      return;
    }

    setState(() => buttonLoginEnabled = false);

    try {
      final user = Provider.of<User>(context, listen: false);
      await user.authentificate(email, password);
      user.mail = email;
      await user.getInfos();
      widget.onLoginSuccess?.call(user.status);
    } catch (error) {
      widget.onLoginError?.call(error);
      _showAlert('Erreur', 'Connexion échouée :\n$error');
    } finally {
      setState(() => buttonLoginEnabled = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Authentification',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          RessourcesRelationellesElements.buildTextField(
                            label: "Adresse mail",
                            controller: _emailController,
                          ),
                          const SizedBox(height: 16),
                          RessourcesRelationellesElements.buildTextField(
                            label: "Mot de passe",
                            controller: _passwordController,
                            isPassword: true,
                          ),
                          const SizedBox(height: 16),
                          OutlinedButton(
                            onPressed: buttonLoginEnabled ? _login : null,
                            child: Text(buttonLoginEnabled
                                ? 'Se connecter'
                                : 'Connexion en cours...'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
