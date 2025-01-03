import 'package:flutter/material.dart';
import 'header.dart';
import 'footer.dart';
import 'device_edit.dart';

class Devices extends StatelessWidget {
  const Devices({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(title: 'Прилади'),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 20), // Add some space from the top
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DeviceEdit()),
                );
              },
              child: Text('Додати'),
            ),
          ),
          // Add your device list or other content here
        ],
      ),
      bottomNavigationBar: Footer(),
    );
  }
}