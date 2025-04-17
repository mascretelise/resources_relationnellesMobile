import 'package:flutter/material.dart';
import 'package:myapp/main.dart' as main;
import 'package:myapp/user.dart';
import 'package:provider/provider.dart'; // wherever you declared your routeObserver

class Accueil extends StatefulWidget {
  const Accueil({super.key});

  @override
  _AccueilState createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> with RouteAware {
  int id = -1;

  void _updateUser() {
    final user = Provider.of<User>(context);
    setState(() {
      id = user.id;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      main.routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    main.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // Called when user navigates back to this page
    _updateUser();
  }

  @override
  void didPush() {
    // Called when this page is initially pushed
    _updateUser();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(id != -1 ? 'Utilisateur connecté !' : 'Kikou'),
    );
  }
}
