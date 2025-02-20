import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_energy/consumption_list.dart';
import 'package:project_energy/widgets/background_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_energy/widgets/footer/bloc/footer_bloc.dart';
import 'header.dart';
import 'widgets/footer/footer.dart';

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
  //bool _showMessage = true;
  double _totalConsumption = 0;

  @override
  void initState() {
    super.initState();
    _hoursController.addListener(_updateCosts);
    _calculateTotalConsumption();
  }

  void _updateCosts() {
    setState(() {
      double hours = double.tryParse(_hoursController.text) ?? 0;
      _dayCost = _calculateCost(dayRate: 20, hours: hours);
      _nightCost = _calculateCost(nightRate: 10, hours: hours);
    });
  }

  double _calculateCost(
      {double dayRate = 0, double nightRate = 0, double hours = 0}) {
    return (dayRate + nightRate) * hours;
  }

  void _calculateTotalConsumption() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('devices')
        .get()
        .then((snapshot) {
      double total = 0;
      for (var doc in snapshot.docs) {
        if (doc['isInConsumptionList'] == true) {
          total += doc['consumptionPerHour'];
        }
      }
      setState(() {
        _totalConsumption = total;
      });
    }).catchError((error) {
      print('Error calculating total consumption: $error');
    });
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
          body: BackgroundWidget(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Сумарне споживання: $_totalConsumption W',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Блок 1 покриває споживання системи',
                          style: TextStyle(color: Colors.white70),
                        ),
                        Text(
                          'Блок 2 не покриває споживання системи',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ConsumptionListScreen()),
                        );
                        if (result == true) {
                          _calculateTotalConsumption();
                        }
                      },
                      child: Text('Список споживання'),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Калькулятор вартості споживання',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
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
                              items: <String>[
                                '2 фази',
                                '1 фаза'
                              ].map<DropdownMenuItem<String>>((String value) {
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
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
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
          ),
          bottomNavigationBar: BlocBuilder<FooterBloc, FooterState>(
            builder: (context, state) {
              int currentIndex = 0;
              if (state is FooterIndexUpdated) {
                currentIndex = state.currentIndex;
              }
              return Footer(currentIndex: currentIndex);
            },
          ),
        ),
        // if (_showMessage)
        //   Message(
        //     message: 'Це тестове сповіщення',
        //     onClose: () {
        //       setState(() {
        //         _showMessage = false;
        //       });
        //     },
        //   ),
      ],
    );
  }
}
