import 'package:flutter/material.dart';

class VisualiseRessource extends StatelessWidget {
  const VisualiseRessource({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [ 
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "A implémenter",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                  ],                    
                ),
              )
            ],
          )
        ]               
      ),
    );
  }
}
