import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_energy/header.dart';
import 'package:project_energy/powerDevices/screen/power_device_edit_screen.dart';
import 'package:project_energy/widgets/background_widget.dart';
import 'package:project_energy/widgets/footer/bloc/footer_bloc.dart';
import 'package:project_energy/widgets/footer/footer.dart';

class PowerDeviceScreen extends StatelessWidget {
  const PowerDeviceScreen({super.key});

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
        title: 'Зарядна станція',
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PowerDeviceEditScreen()),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          BackgroundWidget(
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
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PowerDeviceEditScreen(),
                          ),
                        );
                      },
                      child: const Text('Додати новий девайс'),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: powerDevices.length,
                  itemBuilder: (context, index) {
                    final data = powerDevices[index];
                    final name = data['name'] ?? 'Невідомий пристрій';
                    final capacityWh = data['capacityWh'] ?? 0;
                    final maxPowerOutput = data['maxPowerOutput'] ?? 0;
                    final currentChargeWh = data['currentChargeWh'] ?? 0;
                    final isCharging = data['isCharging'] ?? false;

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: GoogleFonts.raleway(
                                  textStyle: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text('Ємність: $capacityWh Wh',
                                  style: const TextStyle(fontSize: 16)),
                              Text('Макс. потужність: $maxPowerOutput W',
                                  style: const TextStyle(fontSize: 16)),
                              Text('Поточний заряд: $currentChargeWh Wh',
                                  style: const TextStyle(fontSize: 16)),
                              Text(
                                isCharging
                                    ? 'Заряджається...'
                                    : 'Не заряджається',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: isCharging ? Colors.green : Colors.red,
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BlocBuilder<FooterBloc, FooterState>(
              builder: (context, state) {
                int currentIndex = 0;
                if (state is FooterIndexUpdated) {
                  currentIndex = state.currentIndex;
                }
                return Footer(currentIndex: currentIndex);
              },
            ),
          ),
        ],
      ),
    );
  }
}
