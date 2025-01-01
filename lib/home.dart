import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _selectedMeterType = '2 фази';
  final TextEditingController _hoursController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Калькулятор енергоспоживання'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.grey[300],
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Сумарне споживання: 1400 W',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('Блок 1 покриває споживання системи'),
                  Text('Блок 2 не покриває споживання системи'),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              color: Colors.grey[300],
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Тип лічильника: '),
                      SizedBox(width: 10),
                      DropdownButton<String>(
                        value: _selectedMeterType,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedMeterType = newValue!;
                          });
                        },
                        items: <String>['2 фази', '1 фаза']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Text('Час для обрахування(год): '),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _hoursController,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text('Вдень: ${_calculateCost(dayRate: 20)} гривень'),
                  Text('Вночі: ${_calculateCost(nightRate: 10)} гривень'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _calculateCost({dayRate = 0, double nightRate = 0}) {
    double hours = double.tryParse(_hoursController.text) ?? 0;
    return hours * (dayRate + nightRate);
  }
}