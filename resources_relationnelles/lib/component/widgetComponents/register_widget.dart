import 'package:flutter/material.dart';
import 'package:myapp/dataClass/config.dart';
import 'package:myapp/dataClass/user.dart';
import 'package:myapp/component/widgetComponents/ressources_relationelles_elements.dart';
import 'package:provider/provider.dart';

class RegisterWidget extends StatefulWidget {
  const RegisterWidget({
    super.key,
    this.onRegisterSuccess,
    this.onRegisterError,
  });
  final void Function(int status)? onRegisterSuccess;
  final void Function(Object error)? onRegisterError;

  @override
  State<RegisterWidget> createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool mentionLegalesAccepted = false;
  bool cguAccepted = false;
  bool buttonRegisterEnabled = false;

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void showDialogRegister(String texte) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Attention'),
        content: Text(texte),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  bool verifierDonneesUtilisateur(String nom, String prenom, String email,
      String password, String confirmPassword) {
    bool validData = true;
    bool validPassword = true;
    String dataMessage = "Veuillez remplir les champs suivants :\n";
    String passwordMessage = "Votre mot de passe doit contenir au moins : \n";

    if (nom.isEmpty) {
      dataMessage += "- Nom\n";
      validData = false;
    }
    if (prenom.isEmpty) {
      dataMessage += "- Prénom\n";
      validData = false;
    }
    if (email.isEmpty) {
      dataMessage += "- Email\n";
      validData = false;
    }
    if (password.isEmpty) {
      dataMessage += "- Mot de passe\n";
      validData = false;
    }
    if (confirmPassword.isEmpty) {
      dataMessage += "- Veuillez confirmer votre mot de passe\n";
      validData = false;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      dataMessage += "- Adresse mail invalide\n";
      validData = false;
    }

    if (password.length < 10 || password.length > 32) {
      passwordMessage += "- Entre 10 et 32 caractères\n";
      validPassword = false;
    }
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      passwordMessage += "- Une majuscule\n";
      validPassword = false;
    }
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      passwordMessage += "- Une minuscule\n";
      validPassword = false;
    }
    if (!RegExp(r'\d').hasMatch(password)) {
      passwordMessage += "- Un chiffre\n";
      validPassword = false;
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      passwordMessage += "- Un caractère spécial\n";
      validPassword = false;
    }
    if (password != confirmPassword) {
      passwordMessage += "- Les mots de passe ne correspondent pas\n";
      validPassword = false;
    }

    if (!validData) showDialogRegister(dataMessage);
    if (!validPassword) showDialogRegister(passwordMessage);

    return validData && validPassword;
  }

  void showPopupErreurRegister(dynamic error) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Erreur'),
        content: Text(
            "Impossible de joindre le serveur. Veuillez réessayer.\n\n$error"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> register() async {
    final user = Provider.of<User>(context, listen: false);
    user.nom = _nomController.text;
    user.prenom = _prenomController.text;
    user.mail = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    final valid = verifierDonneesUtilisateur(
        user.nom, user.prenom, user.mail, password, confirmPassword);
    if (!valid) return;

    setState(() => buttonRegisterEnabled = false);
    try {
      final user = Provider.of<User>(context, listen: false);
      await user.register(user.nom, user.prenom, user.mail, password);
      await user.authentificate(user.mail, password);
      await user.getInfos();
      widget.onRegisterSuccess?.call(user.status);
    } catch (e) {
      widget.onRegisterError?.call(e);
      setState(() => buttonRegisterEnabled = true);
      showPopupErreurRegister(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("S'enregistrer",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  RessourcesRelationellesElements.buildTextField(
                    label: "Nom",
                    controller: _nomController,
                  ),
                  const SizedBox(height: 16),
                  RessourcesRelationellesElements.buildTextField(
                    label: "Prénom",
                    controller: _prenomController,
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
                  RessourcesRelationellesElements.buildTextField(
                    label: "Confirmer le mot de passe",
                    controller: _confirmPasswordController,
                    isPassword: true,
                  ),
                  const SizedBox(height: 16),
                  CheckboxListTile(
                    title: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Mentions légales"),
                              content: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.9,
                                height:
                                    MediaQuery.of(context).size.height * 0.9,
                                child: SingleChildScrollView(
                                  child: Text(
                                      Config.mentionLegales,),
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text("Fermer"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text(
                        "Afficher les mentions légales",
                        style: TextStyle(
                          fontSize: 15,
                          color: const Color.fromARGB(255, 51, 110, 230),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    value: mentionLegalesAccepted,
                    onChanged: (bool? value) {
                      setState(() {
                        mentionLegalesAccepted = value ?? false;
                        buttonRegisterEnabled = cguAccepted&&mentionLegalesAccepted;
                      });
                    },
                    controlAffinity:
                        ListTileControlAffinity.trailing, // Checkbox à droite
                  ),
                  CheckboxListTile(
                    title: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Conditions Générales d'Utilisation"),
                              content: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.9,
                                height:
                                    MediaQuery.of(context).size.height * 0.9,
                                child: SingleChildScrollView(
                                  child: Text(
                                      Config.conditionGeneralesUtilisation,),
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text("Fermer"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text(
                        "Accepter les CGU",
                        style: TextStyle(
                          fontSize: 15,
                          color: const Color.fromARGB(255, 51, 110, 230),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    value: cguAccepted,
                    onChanged: (bool? value) {
                      setState(() {
                        cguAccepted = value ?? false;
                        buttonRegisterEnabled = cguAccepted&&mentionLegalesAccepted;
                      });
                    },
                    controlAffinity:
                        ListTileControlAffinity.trailing, // Checkbox à droite
                  ),
                  GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Politique de confidentialité"),
                              content: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.9,
                                height:
                                    MediaQuery.of(context).size.height * 0.9,
                                child: SingleChildScrollView(
                                  child: Text(
                                      Config.politiqueConfidentialite,),
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text("Fermer"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text(
                        "Consulter notre politique de confidentialité",
                        style: TextStyle(
                          fontSize: 15,
                          color: const Color.fromARGB(255, 51, 110, 230),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  OutlinedButton(
                    onPressed: buttonRegisterEnabled ? register : null,
                    child: Text(
                        buttonRegisterEnabled ? "S'inscrire" : "S'inscrire"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
