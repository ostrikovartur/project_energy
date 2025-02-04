import 'package:flutter/material.dart';
import 'package:project_energy/authenticationSecond/mainScreen/main_screen.dart';
import 'package:project_energy/authorization.dart';
import 'package:project_energy/devices.dart';
import 'package:project_energy/home.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const Header({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      actions: [
        PopupMenuButton<String>(
          icon: Image.asset('assets/images/menu.png'),
          onSelected: (String result) {
            switch (result) {
              case 'Authorization':
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Authorization()),
                );
                break;
              case 'Home':
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                );
                break;
              case 'Devices':
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Devices()),
                );
                break;
              case 'Auth 2.0':
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainScreen()),
                );
                break;
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'Authorization',
              child: Text('Authorization'),
            ),
            const PopupMenuItem<String>(
              value: 'Home',
              child: Text('Home'),
            ),
            const PopupMenuItem<String>(
              value: 'Devices',
              child: Text('Devices'),
            ),
            const PopupMenuItem<String>(
              value: 'Auth 2.0',
              child: Text('Auth 2.0'),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
