class Device {
  final String name;
  final double consumptionPerHour;
  final double consumptionPerYear;

  Device({
    required this.name,
    required this.consumptionPerHour,
    required this.consumptionPerYear,
  });

    Map<String, dynamic> toJson() {
    return {
      'name': name,
      'consumptionPerHour': consumptionPerHour,
      'consumptionPerYear': consumptionPerYear,
    };
  }
}