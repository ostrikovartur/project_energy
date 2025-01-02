import 'package:flutter/material.dart';
import 'header.dart';
import 'footer.dart';

class Devices extends StatelessWidget {
  const Devices({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(title: 'Прилади'),
      body: Column(
        children: [
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Add your onPressed code here!
            },
            child: Text('Додати'),
          ),
          // Add your device list or other content here
        ],
      ),
      bottomNavigationBar: Footer(),
    );
  }
}