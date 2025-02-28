import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_energy/header.dart';
import 'package:project_energy/powerDevices/power_device.dart';
import 'package:project_energy/powerDevices/screen/power_device_edit_screen.dart';
import 'package:project_energy/widgets/background_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PowerDeviceScreen extends StatefulWidget {
  final PowerDevice powerDevice;

  const PowerDeviceScreen({super.key, required this.powerDevice});

  @override
  _PowerDeviceScreenState createState() => _PowerDeviceScreenState();
}

class _PowerDeviceScreenState extends State<PowerDeviceScreen> with SingleTickerProviderStateMixin {
  late bool _isCharging;

  @override
  void initState() {
    super.initState();
    _isCharging = widget.powerDevice.isCharging;
  }

  @override
  void dispose() {
    _saveChargingState();
    super.dispose();
  }

  // Функція для збереження змін у базу
  Future<void> _saveChargingState() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final deviceRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('power_devices')
          .doc(widget.powerDevice.id); // Ідентифікатор пристрою

      await deviceRef.update({
        'isCharging': _isCharging,
      });

      print("Змінено стан заряджання для пристрою ${widget.powerDevice.name}");
    } catch (e) {
      print("Помилка при оновленні стану заряджання: $e");
    }
  }

  // Функція для зміни стану заряджання
  void _toggleChargingState() {
    setState(() {
      _isCharging = !_isCharging;
    });
  }

  @override
  Widget build(BuildContext context) {
    final chargePercentage = (widget.powerDevice.capacityWh > 0)
        ? ((widget.powerDevice.currentChargeWh / widget.powerDevice.capacityWh) * 100).round()
        : 0;

    Color batteryColor;
    if (chargePercentage >= 70) {
      batteryColor = Colors.green;
    } else if (chargePercentage >= 30) {
      batteryColor = Colors.orange;
    } else {
      batteryColor = Colors.red;
    }

    return Scaffold(
      appBar: Header(
        title: widget.powerDevice.name,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Перехід до екрану налаштувань пристрою
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PowerDeviceEditScreen(
                    powerDevice: widget.powerDevice, // передаємо пристрій для редагування
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: BackgroundWidget(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GestureDetector(
                  onTap: _toggleChargingState, // обробка натискання на коло
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: CircularProgressIndicator(
                          value: chargePercentage / 100,
                          strokeWidth: 40,
                          valueColor: AlwaysStoppedAnimation(batteryColor),
                          backgroundColor: Colors.grey[300],
                        ),
                      ),
                      if (_isCharging)
                        Positioned(
                          top: 20,
                          child: Icon(
                            Icons.flash_on,
                            color: Colors.yellow,
                            size: 40,
                          ),
                        ),
                      Text(
                        '$chargePercentage%',
                        style: GoogleFonts.raleway(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Детальна інформація',
                style: GoogleFonts.raleway(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                '• Назва: ${widget.powerDevice.name}',
                style: GoogleFonts.raleway(fontSize: 18),
              ),
              Text(
                '• Ємність: ${widget.powerDevice.capacityWh} Вт·год',
                style: GoogleFonts.raleway(fontSize: 18),
              ),
              Text(
                '• Поточний заряд: ${widget.powerDevice.currentChargeWh} Вт·год',
                style: GoogleFonts.raleway(fontSize: 18),
              ),
              Text(
                '• Заряд у відсотках: $chargePercentage%',
                style: GoogleFonts.raleway(fontSize: 18),
              ),
              Text(
                '• Макс. вихідна потужність: ${widget.powerDevice.maxPowerOutput} Вт',
                style: GoogleFonts.raleway(fontSize: 18),
              ),
              Text(
                '• Заряджається зараз: ${_isCharging ? "Так" : "Ні"}',
                style: GoogleFonts.raleway(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
