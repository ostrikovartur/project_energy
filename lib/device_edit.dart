import 'package:flutter/material.dart';
import 'header.dart';
import 'footer.dart';

class DeviceEdit extends StatefulWidget {
  const DeviceEdit({super.key});

  @override
  _DeviceEditState createState() => _DeviceEditState();
}

class _DeviceEditState extends State<DeviceEdit> {
  final TextEditingController _deviceNameController = TextEditingController();
  final TextEditingController _consumptionPerHourController = TextEditingController();
  final TextEditingController _consumptionPerYearController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _consumptionPerHourController.addListener(_calculateAnnualConsumption);
  }

  @override
  void dispose() {
    _deviceNameController.dispose();
    _consumptionPerHourController.dispose();
    _consumptionPerYearController.dispose();
    super.dispose();
  }

  void _calculateAnnualConsumption() {
    final double consumptionPerHour = double.tryParse(_consumptionPerHourController.text) ?? 0;
    final double consumptionPerYear = consumptionPerHour * 24 * 365 / 1000; // Convert to kWt/year
    _consumptionPerYearController.text = consumptionPerYear.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(title: 'Налаштування пристрою'),
      body: Padding(
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
            // Add your device editing form or content here
          ],
        ),
      ),
      bottomNavigationBar: Footer(),
    );
  }
}