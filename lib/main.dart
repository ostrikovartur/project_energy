import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'authorization.dart';
import 'home.dart';
import 'devices.dart';
import 'device_edit.dart';
import 'package:flutter/widgets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyD9dzSI7e2UmxOZY-FkO4m71ytucxss9X0',
      appId: '1:83780161459:android:03eafdf6b1f4cdaf8005c6',
      messagingSenderId: '83780161459',
      projectId: 'projectenergy-85a9b',
      storageBucket: 'projectenergy-85a9b.appspot.com',
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project Energy',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/authorization',
      routes: {
        '/authorization': (context) => Authorization(),
        '/home': (context) => Home(),
        '/devices': (context) => Devices(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/device_edit') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) {
              return DeviceEdit(
                deviceId: args['deviceId'],
                deviceName: args['deviceName'],
                consumptionPerHour: args['consumptionPerHour'],
              );
            },
          );
        }
        return null;
      },
      home: Scaffold(),
    );
  }
}
