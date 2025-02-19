import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_energy/widgets/background_widget.dart';
import 'header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeviceEdit extends StatefulWidget {
  final String deviceId;
  final String deviceName;
  final double consumptionPerHour;
  final bool isInConsumptionList;

  const DeviceEdit({
    super.key,
    required this.deviceId,
    required this.deviceName,
    required this.consumptionPerHour,
    this.isInConsumptionList = false,
  });

  @override
  _DeviceEditState createState() => _DeviceEditState();
}

class _DeviceEditState extends State<DeviceEdit> {
  late TextEditingController _deviceNameController;
  late TextEditingController _consumptionPerHourController;
  late TextEditingController _consumptionPerYearController;
  bool _isInConsumptionList = false;

  @override
  void initState() {
    super.initState();
    _deviceNameController = TextEditingController(text: widget.deviceName);
    _consumptionPerHourController = TextEditingController(text: widget.consumptionPerHour == 0 ? '' : widget.consumptionPerHour.toString());
    _consumptionPerYearController = TextEditingController();
    _isInConsumptionList = widget.isInConsumptionList;
    _consumptionPerHourController.addListener(_calculateAnnualConsumption);
    _calculateAnnualConsumption();
  }

  @override
  void dispose() {
    _deviceNameController.dispose();
    _consumptionPerHourController.dispose();
    _consumptionPerYearController.dispose();
    super.dispose();
  }

  void _calculateAnnualConsumption() {
    final double consumptionPerHour =
        double.tryParse(_consumptionPerHourController.text) ?? 0;
    final double consumptionPerYear = consumptionPerHour * 24 * 365 / 1000;
    _consumptionPerYearController.text = consumptionPerYear.toStringAsFixed(2);
  }

  void _saveDevice() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Користувач не авторизований')),
      );
      return;
    }

    CollectionReference devices = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('devices');

    final String name = _deviceNameController.text;
    final double consumptionPerHour =
        double.tryParse(_consumptionPerHourController.text) ?? 0;
    final double consumptionPerYear =
        double.tryParse(_consumptionPerYearController.text) ?? 0;

    final deviceData = {
      'name': name,
      'consumptionPerHour': consumptionPerHour,
      'consumptionPerYear': consumptionPerYear,
      'isInConsumptionList': _isInConsumptionList,
    };

    if (widget.deviceId.isEmpty) {
      await devices.add(deviceData);
    } else {
      await devices.doc(widget.deviceId).update(deviceData);
    }
    Navigator.pop(context);
  }

  void _deleteDevice() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Користувач не авторизований')),
      );
      return;
    }

    if (widget.deviceId.isNotEmpty) {
      CollectionReference devices = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('devices');

      await devices.doc(widget.deviceId).delete();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(title: 'Налаштування пристрою'),
      body: BackgroundWidget(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _deviceNameController,
              decoration: InputDecoration(
                labelText: 'Назва пристрою',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
                controller: _consumptionPerHourController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Споживання (Вт/год)',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  if (value.isEmpty) {
                    _consumptionPerHourController.text = '';
                  }
                },
              ),
            SizedBox(height: 16),
            TextField(
              controller: _consumptionPerYearController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Споживання (кВт/рік)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            CheckboxListTile(
              title: Text('Присутній в списку споживання'),
              value: _isInConsumptionList,
              onChanged: (bool? value) {
                setState(() {
                  _isInConsumptionList = value ?? false;
                });
              },
            ),
            SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _saveDevice,
                  child: Text('Зберегти'),
                ),
                if (widget.deviceId.isNotEmpty) ...[
                  SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _deleteDevice,
                    child: Text('Видалити'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      )),
    );
  }
}
