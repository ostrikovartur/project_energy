import 'package:flutter/material.dart';
import 'package:project_energy/devices.dart';
import 'package:project_energy/home.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.075, // Adjust this value to control the height percentage
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: EdgeInsets.all(8.0),
        color: Colors.black38,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Devices()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.lightbulb),
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
