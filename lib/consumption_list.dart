import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_energy/authenticationSecond/bloc/authentication_bloc.dart';
import 'package:project_energy/header.dart';
import 'package:project_energy/widgets/background_widget.dart';

class ConsumptionListScreen extends StatefulWidget {
  @override
  _ConsumptionListScreenState createState() => _ConsumptionListScreenState();
}

class _ConsumptionListScreenState extends State<ConsumptionListScreen> {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  Map<String, bool> _deviceSelections = {};
  Map<String, bool> _initialDeviceSelections = {};
  List<QueryDocumentSnapshot>? _devices;

  @override
  void initState() {
    super.initState();
    _loadDevices();
  }

  void _loadDevices() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('devices')
        .get();
    setState(() {
      _devices = snapshot.docs;
      for (var doc in _devices!) {
        bool isSelected = doc['isInConsumptionList'] ?? false;
        _deviceSelections[doc.id] = isSelected;
        _initialDeviceSelections[doc.id] = isSelected;
      }
    });
  }

  bool get _hasChanges => !_deviceSelections.keys.every((key) => _deviceSelections[key] == _initialDeviceSelections[key]);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state.status == AuthenticationStatus.unauthenticated) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: Header(title: 'Consumption List'),
        body: Stack(
          children: [
            BackgroundWidget(
              child: _devices == null
                  ? Center(child: CircularProgressIndicator())
                  : _devices!.isEmpty
                      ? Center(child: Text('No devices found'))
                      : Column(
                          children: [
                            Expanded(
                              child: ListView(
                                padding: EdgeInsets.all(16),
                                children: _devices!.map((doc) {
                                  String deviceId = doc.id;
                                  return Card(
                                    margin: EdgeInsets.symmetric(vertical: 8),
                                    child: ListTile(
                                      title: Text(doc['name'] ?? 'Unknown Device'),
                                      subtitle: Text('Consumption: ${doc['consumptionPerHour']} W/h'),
                                      trailing: Checkbox(
                                        value: _deviceSelections[deviceId],
                                        onChanged: (bool? value) {
                                          setState(() {
                                            _deviceSelections[deviceId] = value ?? false;
                                          });
                                        },
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Назад'),
                                  ),
                                  ElevatedButton(
                                    onPressed: _hasChanges ? _saveChanges : null,
                                    child: Text('Зберегти список'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
            ),
          ],
        ),
      ),
    );
  }

void _saveChanges() {
  final batch = FirebaseFirestore.instance.batch();
  _deviceSelections.forEach((deviceId, isInConsumptionList) {
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('devices')
        .doc(deviceId);
    batch.update(docRef, {'isInConsumptionList': isInConsumptionList});
  });

  batch.commit().then((_) {
    Navigator.pop(context, true);
  }).catchError((error) {
    print('Error saving changes: $error');
  });
}

}
