import 'package:flutter/material.dart';
import 'package:myapp/Pages/accueil.dart';
import 'package:myapp/Pages/login.dart';

class Nav extends StatefulWidget {
  const Nav({super.key});

  @override
  State<Nav> createState() => _NavState();
}

class _NavState extends State<Nav> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    Accueil(),
    Text(
        'Paramètres'), //Change le texte en paramètre à l'appui du bouton à l'index 2.
    Login(), //Affiche la page test.dart à l'appui du bouton à l'index 3.
  ];

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CircleAvatar(
          backgroundImage: AssetImage('assets/images/logo.png'),
          radius: 25,
        ),
        backgroundColor: Colors.blue[100],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: 'Compte',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Paramètres',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Connexion',
          )
        ],
        backgroundColor: Colors.blue[100],
        currentIndex: _selectedIndex,
        onTap: _onItemTap,
      ),
    );
  }
}
