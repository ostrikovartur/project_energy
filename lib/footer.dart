import 'package:flutter/material.dart';
import 'package:project_energy/devices.dart';
import 'package:project_energy/home.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.1, // Adjust this value to control the height percentage
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: EdgeInsets.all(16.0),
        color: Colors.grey[300],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Image.asset('assets/images/homeLogo.png'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Devices()),
                );
              },
            ),
            IconButton(
              icon: Image.asset('assets/images/calculator.png'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
