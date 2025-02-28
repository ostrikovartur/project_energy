import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_energy/powerDevices/power_device.dart';

class PowerDeviceEditScreen extends StatefulWidget {
  final PowerDevice powerDevice;

  const PowerDeviceEditScreen({super.key, required this.powerDevice});

  @override
  _PowerDeviceEditScreenState createState() => _PowerDeviceEditScreenState();
}

class _PowerDeviceEditScreenState extends State<PowerDeviceEditScreen> {
  final _nameController = TextEditingController();
  final _capacityController = TextEditingController();
  final _maxPowerController = TextEditingController();
  final _currentChargeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Ініціалізація контролерів значеннями з powerDevice
    _nameController.text = widget.powerDevice.name;
    _capacityController.text = widget.powerDevice.capacityWh.toString();
    _maxPowerController.text = widget.powerDevice.maxPowerOutput.toString();
    _currentChargeController.text =
        widget.powerDevice.currentChargeWh.toString();
  }

  void _savePowerDevice() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Користувач не авторизований')),
    );
    return;
  }

  final name = _nameController.text;
  final capacity = double.tryParse(_capacityController.text) ?? 0;
  final maxPower = double.tryParse(_maxPowerController.text) ?? 0;
  final currentCharge = double.tryParse(_currentChargeController.text) ?? 0;

  if (name.isEmpty || capacity <= 0 || maxPower <= 0) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Будь ласка, заповніть усі поля коректно')),
    );
    return;
  }

  try {
    final powerDevicesCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('power_devices');

    final powerDeviceData = {
      'name': name,
      'capacityWh': capacity,
      'maxPowerOutput': maxPower,
      'currentChargeWh': currentCharge,
      'isCharging': widget.powerDevice.id.isEmpty ? false : widget.powerDevice.isCharging, // Додаємо isCharging тільки при створенні нового пристрою
    };

    if (widget.powerDevice.id.isEmpty) {
      // Створюємо новий пристрій
      await powerDevicesCollection.add(powerDeviceData);
    } else {
      // Оновлюємо існуючий пристрій
      await powerDevicesCollection
          .doc(widget.powerDevice.id)
          .update(powerDeviceData);
    }

    Navigator.pop(context);
  } catch (e) {
    print("Error saving power device: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Помилка при збереженні пристрою')),
    );
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
