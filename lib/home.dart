import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'header.dart';
import 'footer.dart';
import 'message.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _selectedMeterType = '2 фази';
  final TextEditingController _hoursController = TextEditingController();
  double _dayCost = 0;
  double _nightCost = 0;
  bool _showMessage = true;

  @override
  void initState() {
    super.initState();
    _hoursController.addListener(_updateCosts);
  }

  void _updateCosts() {
    setState(() {
      double hours = double.tryParse(_hoursController.text) ?? 0;
      _dayCost = _calculateCost(dayRate: 20, hours: hours);
      _nightCost = _calculateCost(nightRate: 10, hours: hours);
    });
  }

  double _calculateCost({double dayRate = 0, double nightRate = 0, double hours = 0}) {
    return (dayRate + nightRate) * hours;
  }

  @override
  void dispose() {
    _hoursController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: Header(title: 'Home'),
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
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                              ],
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text('Вдень: $_dayCost гривень'),
                      Text('Вночі: $_nightCost гривень'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Footer(),
        ),
        if (_showMessage)
          Message(
            message: 'Це тестове сповіщення',
            onClose: () {
              setState(() {
                _showMessage = false;
              });
            },
          ),
      ],
    );
  }
}