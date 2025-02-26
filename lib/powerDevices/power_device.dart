import 'package:project_energy/device.dart';

  // final String id;
  // final String name;
  // final double capasity; //Вт/год
  // final double outputPower; //Вт
  // final double maxOutputPower; //Вт
  // final double chargeTime; //год

class PowerDevice {
  final String id;
  final String name;
  final double capacityWh; // Загальна ємність акумулятора (Wh)
  final double maxPowerOutput; // Макс. потужність, яку можна віддати (W)
  double currentChargeWh; // Поточний заряд акумулятора (Wh)
  final bool isCharging; // Чи заряджається він зараз

  PowerDevice({
    required this.id,
    required this.name,
    required this.capacityWh,
    required this.maxPowerOutput,
    required this.currentChargeWh,
    this.isCharging = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'capacityWh': capacityWh,
      'maxPowerOutput': maxPowerOutput,
      'currentChargeWh': currentChargeWh,
      'isCharging': isCharging,
    };
  }

  static PowerDevice fromMap(String id, Map<String, dynamic> map) {
    return PowerDevice(
      id: id,
      name: map['name'],
      capacityWh: map['capacityWh'],
      maxPowerOutput: map['maxPowerOutput'],
      currentChargeWh: map['currentChargeWh'],
      isCharging: map['isCharging'] ?? false,
    );
  }

  /// **Функція підключення пристроїв**
  bool canPowerDevices(List<Device> devices) {
    double totalPower = devices.fold(0, (sum, device) => sum + device.consumptionPerHour);
    return totalPower <= maxPowerOutput && currentChargeWh > 0;
  }

  /// **Оновлення рівня заряду акумулятора при роботі**
  void updateCharge(List<Device> devices, double hours, double efficiency) {
    double totalConsumption = devices.fold(0, (sum, device) => sum + device.consumptionPerHour);
    
    if (canPowerDevices(devices)) {
      double energyUsed = totalConsumption * hours / efficiency;
      currentChargeWh = (currentChargeWh - energyUsed).clamp(0, capacityWh);
    }
  }

  /// **Час роботи акумулятора з поточним зарядом**
  double estimatedRuntime(List<Device> devices, double efficiency) {
    double totalConsumption = devices.fold(0, (sum, device) => sum + device.consumptionPerHour);
    return totalConsumption > 0 ? (currentChargeWh * efficiency) / totalConsumption : double.infinity;
  }
}
