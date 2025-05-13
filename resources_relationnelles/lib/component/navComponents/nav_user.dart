import 'package:flutter/material.dart';
import 'package:myapp/Pages/accueil.dart';
import 'package:myapp/Pages/settings.dart';
import 'package:myapp/Pages/visualise_ressource.dart';
import 'package:myapp/Pages/export_ressource.dart';
import 'package:myapp/dataClass/themeProvider.dart';
import 'package:provider/provider.dart';

/*
> Entête de l'application avec nom/icone et rouleau de navigation

*/

class NavUser extends StatelessWidget {
  const NavUser({super.key, this.toggleTheme});
  final VoidCallback? toggleTheme;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return DefaultTabController(
      length: 4, // Nombre d'onglets
      child: SafeArea(
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
            backgroundColor: themeProvider.isDarkMode
                ? Color.fromARGB(255, 2, 105, 25)
                : Color.fromARGB(255, 55, 245, 38),
            bottom: const TabBar(
              tabs: [
                //Définis les icones et le nom des boutons de navigation
                Tab(icon: Icon(Icons.account_circle_outlined), text: 'Compte'),
                Tab(icon: Icon(Icons.settings), text: 'Paramètres'),
                Tab(icon: Icon(Icons.file_upload), text: 'Upload'),
                Tab(icon: Icon(Icons.file_copy), text: 'Banque de ressources'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              //Instanciation des classes définies dans le répertoire des pages dans l'ordre des tabs
              Accueil(),
              Settings(toggleTheme: toggleTheme!),
              ExportRessource(),
              VisualiseRessource(),
              //ClasseDunePage(),
            ],
          ),
        ),
      ),
    );
  }
}
