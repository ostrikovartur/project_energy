import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PowerDeviceEditScreen extends StatefulWidget {
  const PowerDeviceEditScreen({super.key});

  @override
  _PowerDeviceEditScreenState createState() => _PowerDeviceEditScreenState();
}

class _PowerDeviceEditScreenState extends State<PowerDeviceEditScreen> {
  final _nameController = TextEditingController();
  final _capacityController = TextEditingController();
  final _maxPowerController = TextEditingController();
  final _currentChargeController = TextEditingController();

  Future<void> _savePowerDevice() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final name = _nameController.text;
    final capacity = int.tryParse(_capacityController.text) ?? 0;
    final maxPower = int.tryParse(_maxPowerController.text) ?? 0;
    final currentCharge = int.tryParse(_currentChargeController.text) ?? 0;

    if (name.isEmpty || capacity <= 0 || maxPower <= 0) {
      return;
    }

    try {
      final newDeviceRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('power_devices')
          .doc();

      await newDeviceRef.set({
        'name': name,
        'capacityWh': capacity,
        'maxPowerOutput': maxPower,
        'currentChargeWh': currentCharge,
        'isCharging': false,
      });

      Navigator.pop(context); 
    } catch (e) {
      print("Error saving power device: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Редагувати зарядну станцію')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Назва пристрою'),
            ),
            TextField(
              controller: _capacityController,
              decoration: const InputDecoration(labelText: 'Ємність (Wh)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _maxPowerController,
              decoration:
                  const InputDecoration(labelText: 'Макс. потужність (W)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _currentChargeController,
              decoration:
                  const InputDecoration(labelText: 'Поточний заряд (Wh)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _savePowerDevice,
              child: const Text('Зберегти'),
            ),
          ],
        ),
      ),
    );
  }
}
