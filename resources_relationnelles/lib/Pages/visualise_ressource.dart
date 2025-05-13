import 'package:flutter/material.dart';
import 'package:myapp/component/widgetComponents/search_ressources.dart';

class VisualiseRessource extends StatelessWidget {
  const VisualiseRessource({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SearchRessources());
  }
}
