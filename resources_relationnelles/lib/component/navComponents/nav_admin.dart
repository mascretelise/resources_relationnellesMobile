import 'package:flutter/material.dart';
import 'package:myapp/Pages/accueil.dart';
import 'package:myapp/Pages/categories.dart';
import 'package:myapp/Pages/settings.dart';
import 'package:myapp/Pages/visualise_ressource.dart';
import 'package:myapp/Pages/export_ressource.dart';
import 'package:myapp/dataClass/themeProvider.dart';
import 'package:provider/provider.dart';

/*
> Entête de l'application avec nom/icone et rouleau de navigation

*/

class NavAdmin extends StatelessWidget {
  final VoidCallback? toggleTheme;

  const NavAdmin({super.key, this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return DefaultTabController(
      length: 5,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('(Re)Sources Relationnelles'),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.brightness_6),
                      onPressed: toggleTheme,
                    ),
                    const SizedBox(width: 8),
                    const CircleAvatar(
                      backgroundImage: AssetImage('assets/images/logo.png'),
                      radius: 20,
                    ),
                  ],
                ),
              ],
            ),
            backgroundColor: themeProvider.isDarkMode
                ? Color.fromARGB(255, 167, 92, 2)
                : Color.fromARGB(255, 255, 165, 0),
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.account_circle_outlined), text: 'Compte'),
                Tab(icon: Icon(Icons.settings), text: 'Paramètres'),
                Tab(icon: Icon(Icons.file_upload), text: 'Upload'),
                Tab(icon: Icon(Icons.file_copy), text: 'Banque de ressources'),
                Tab(icon: Icon(Icons.filter_list), text: 'Catégories'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Accueil(),
              Settings(toggleTheme: toggleTheme!),
              ExportRessource(),
              VisualiseRessource(),
              Categories(),
            ],
          ),
        ),
      ),
    );
  }
}
