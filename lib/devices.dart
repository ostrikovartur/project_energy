import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_energy/device_edit.dart';
import 'package:project_energy/widgets/background_widget.dart';
import 'header.dart';
import 'widgets/footer/footer.dart';

class Devices extends StatefulWidget {
  const Devices({super.key});

  @override
  _DevicesState createState() => _DevicesState();
}

Stream<QuerySnapshot> _getUserDevicesStream() {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    return Stream.empty(); // Порожній стрім, якщо користувач не авторизований
  }

  return FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('devices')
      .snapshots();
}

class _DevicesState extends State<Devices> {
  bool _showAllDevices = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(title: 'Прилади'),
      body: BackgroundWidget(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DeviceEdit(
                        deviceId: '',
                        deviceName: '',
                        consumptionPerHour: 0,
                        isInConsumptionList: false,
                      ),
                    ),
                  );
                },
                child: Text('Додати'),
              ),
              SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _showAllDevices = !_showAllDevices;
                  });
                },
                child: Text(
                    _showAllDevices ? 'Показати останні три' : 'Показати всі'),
              ),
            ],
          ),
          SizedBox(height: 20),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  _getUserDevicesStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final devices = snapshot.data!.docs;
                final displayedDevices =
                    _showAllDevices ? devices : devices.take(3).toList();

                return ListView.builder(
                  itemCount: displayedDevices.length,
                  itemBuilder: (context, index) {
                    final device = displayedDevices[index];
                    final deviceName = device['name'];
                    final consumptionPerHour = device['consumptionPerHour'];
                    final isInConsumptionList = device['isInConsumptionList'];

                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        title: Text(deviceName),
                        subtitle:
                            Text('Споживання: $consumptionPerHour Вт/год'),
                        trailing: IconButton(
                          icon: Icon(Icons.arrow_forward),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DeviceEdit(
                                  deviceId: device.id,
                                  deviceName: deviceName,
                                  consumptionPerHour: consumptionPerHour,
                                  isInConsumptionList: isInConsumptionList,
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
      )),
      bottomNavigationBar: Footer(currentIndex: 1),
    );
  }
}
