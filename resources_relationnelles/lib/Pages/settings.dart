import 'package:flutter/material.dart';
import 'package:myapp/user_config.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late UserConfig userConfig;

  @override
  void initState() {
    super.initState();
    userConfig = UserConfig(); //Initialisation
    userConfig.loadFromJson().then((_) {
      setState(() {}); //Attend que le fichier Json aît été traité
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                BuildSwitch(
                  title: 'Se souvenir de moi',
                  settingValue: userConfig.rememberUsername,
                  onChanged: (value) {
                    setState(() {
                      userConfig.rememberUsername = value;
                    });
                  },
                ),
                BuildSwitch(
                  title: 'Mode nuit',
                  settingValue: userConfig.nightMode,
                  onChanged: (value) {
                    setState(() {
                      userConfig.nightMode = value;
                    });
                  },
                ),
                BuildSwitch(
                  title: 'Mode daltonien',
                  settingValue: userConfig.colorblind,
                  onChanged: (value) {
                    setState(() {
                      userConfig.colorblind = value;
                    });
                  },
                ),
                OutlinedButton(
                  onPressed: () {
                    userConfig.saveSettings(); //Méthode à faire
                  },
                  child: const Text("Enregistrer mes préférences"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BuildSwitch extends StatefulWidget {
  final String title; //Titre du switch
  bool settingValue; //Valeur initiale
  final ValueChanged<bool> onChanged; //Callback pour le parent

  BuildSwitch({ //Construit le switch avec les différentes valeurs
    super.key, 
    required this.title,
    required this.settingValue,
    required this.onChanged,
  });

  @override
  State<BuildSwitch> createState() => _BuildSwitchState(); //Création du switch
}

class _BuildSwitchState extends State<BuildSwitch> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0), //Padding sur les côtés
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            widget.title, //Titre du switch
            style: const TextStyle(fontSize: 16),
          ),
          Transform.scale(
            scale: 0.75, //Réduit la taille du switch
            child: Switch(
              value: widget.settingValue, //Récupère la valeur du fichier Json (ou false)
              onChanged: (bool value) {
                setState(() {
                  widget.settingValue = value; //Met à jour la valeur en elle-même
                });
                widget.onChanged(value); //Change le switch sur l'interface
              },
            ),
          ),
        ],
      ),
    );
  }
}