import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BatteryWidget extends StatelessWidget {
  final int chargePercentage;

  const BatteryWidget({super.key, required this.chargePercentage});

  @override
  Widget build(BuildContext context) {
    IconData batteryIcon;
    Color batteryColor;

    if (chargePercentage >= 90) {
      batteryIcon = Icons.battery_full;
      batteryColor = Colors.green;
    } else if (chargePercentage >= 70) {
      batteryIcon = Icons.battery_6_bar;
      batteryColor = Colors.lightGreen;
    } else if (chargePercentage >= 50) {
      batteryIcon = Icons.battery_4_bar;
      batteryColor = Colors.yellow;
    } else if (chargePercentage >= 30) {
      batteryIcon = Icons.battery_3_bar;
      batteryColor = Colors.orange;
    } else if (chargePercentage >= 10) {
      batteryIcon = Icons.battery_1_bar;
      batteryColor = Colors.red;
    } else {
      batteryIcon = Icons.battery_alert;
      batteryColor = Colors.redAccent;
    }

    return Row(
      children: [
        Icon(batteryIcon, color: batteryColor, size: 24),
        const SizedBox(width: 5),
        Text('$chargePercentage%', style: GoogleFonts.raleway(fontSize: 16)),
      ],
    );
  }
}
