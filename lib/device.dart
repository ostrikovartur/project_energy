import 'package:cloud_firestore/cloud_firestore.dart';
import 'repository.dart';

class Device {
  final String id;
  final String name;
  final double consumptionPerHour;
  final double consumptionPerYear;
  final bool isInConsumptionList;

  Device({
    required this.id,
    required this.name,
    required this.consumptionPerHour,
    required this.consumptionPerYear,
    this.isInConsumptionList = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'consumptionPerHour': consumptionPerHour,
      'consumptionPerYear': consumptionPerYear,
      'isInConsumptionList': isInConsumptionList,
    };
  }

  static Device fromMap(String id, Map<String, dynamic> map) {
    return Device(
      id: id,
      name: map['name'],
      consumptionPerHour: map['consumptionPerHour'],
      consumptionPerYear: map['consumptionPerYear'],
      isInConsumptionList: map['isInConsumptionList'] ?? false,
    );
  }
}

class DeviceRepository extends BaseRepository<Device> {
  DeviceRepository() : super(FirebaseFirestore.instance.collection('devices'));

  @override
  Map<String, dynamic> itemToMap(Device item) {
    return item.toMap();
  }

  @override
  Device mapToItem(Map<String, dynamic> map) {
    return Device.fromMap(map['id'], map);
  }
}