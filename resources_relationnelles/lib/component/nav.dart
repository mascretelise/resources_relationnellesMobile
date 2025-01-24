import 'package:flutter/material.dart';
import 'package:myapp/Pages/accueil.dart';
import 'package:myapp/Pages/login.dart';
import 'package:myapp/Pages/register.dart';
import 'package:myapp/Pages/settings.dart';

/*
> Entête de l'application avec nom/icone et rouleau de navigation

*/

class Nav extends StatelessWidget {
  const Nav({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // Nombre d'onglets
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('(Re)Sources Relationnelles'), //Nom de l'appli
              CircleAvatar(
                backgroundImage: AssetImage('assets/images/logo.png'),
                radius: 20,
              ),
            ],
          ),
          backgroundColor: Colors.blue[100],
          bottom: const TabBar(
            tabs: [
              //Définis les icones et le nom des boutons de navigation
              Tab(icon: Icon(Icons.account_circle_outlined), text: 'Compte'),
              Tab(icon: Icon(Icons.settings), text: 'Paramètres'),
              Tab(icon: Icon(Icons.login), text: 'Connexion'),
              Tab(
                  icon: Icon(Icons.app_registration_rounded),
                  text: 'Inscrption'),
              //Tab(icon: Icon(Icons.NomIcone), text: 'Texte du tab'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            //Instanciation des classes définies dans le répertoire des pages dans l'ordre des tabs
            Accueil(),
            Settings(),
            Login(),
            Register(),
            //ClasseDunePage(),
          ],
        ),
      ),
    );
  }
}
