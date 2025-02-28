import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_energy/header.dart';
import 'package:project_energy/powerDevices/power_device.dart';
import 'package:project_energy/powerDevices/screen/power_device_edit_screen.dart';
import 'package:project_energy/powerDevices/screen/power_device_screen.dart';
import 'package:project_energy/widgets/background_widget.dart';
import 'package:project_energy/widgets/battery_widget.dart';
import 'package:project_energy/widgets/footer/bloc/footer_bloc.dart';
import 'package:project_energy/widgets/footer/footer.dart';

class PowerDevicesListScreen extends StatelessWidget {
  const PowerDevicesListScreen({super.key});

  Stream<QuerySnapshot> _getUserPowerDeviceStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Stream.empty();
    }
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('power_devices')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(
        title: 'Зарядні станції',
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PowerDeviceEditScreen(
                    powerDevice: PowerDevice(
                      id: '',
                      name: '',
                      capacityWh: 0.0,
                      currentChargeWh: 0.0,
                      maxPowerOutput: 0.0,
                      isCharging: false,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: BackgroundWidget(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _getUserPowerDeviceStream(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final powerDevices = snapshot.data!.docs;

                  if (powerDevices.isEmpty) {
                    return Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PowerDeviceEditScreen(
                                powerDevice: PowerDevice(
                                  id: '', // Для нового пристрою
                                  name: '',
                                  capacityWh: 0.0,
                                  currentChargeWh: 0.0,
                                  maxPowerOutput: 0.0,
                                  isCharging: false,
                                ),
                              ),
                            ),
                          );
                        },
                        child: const Text('Додати нову станцію'),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: powerDevices.length,
                    itemBuilder: (context, index) {
                      final data = powerDevices[index];
                      final deviceId = data.id;
                      final name = data['name'] ?? 'Невідомий пристрій';
                      final capacityWh = data['capacityWh'] ?? 0;
                      final currentChargeWh = data['currentChargeWh'] ?? 0;
                      final chargePercentage = (capacityWh > 0)
                          ? ((currentChargeWh / capacityWh) * 100).round()
                          : 0;

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 5,
                          child: ListTile(
                            title: Text(
                              name,
                              style: GoogleFonts.raleway(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: BatteryWidget(
                                chargePercentage: chargePercentage),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PowerDeviceScreen(
                                    powerDevice: PowerDevice(
                                      id: deviceId,
                                      name: name,
                                      capacityWh: capacityWh.toDouble(),
                                      currentChargeWh:
                                          currentChargeWh.toDouble(),
                                      maxPowerOutput:
                                          (data['maxPowerOutput'] ?? 0)
                                              .toDouble(),
                                      isCharging: data['isCharging'] ?? false,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
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
    );
  }
}
