import 'dart:ui';
import 'package:flutter/material.dart';

class BackgroundWidget extends StatelessWidget {
  final Widget child;

  const BackgroundWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        children: [
          Align(
            alignment: const Alignment(20, -1.2),
            child: Container(
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
          ),
          Align(
            alignment: const Alignment(-2.7, -1.2),
            child: Container(
              height: MediaQuery.of(context).size.width / 1.3,
              width: MediaQuery.of(context).size.width / 1.3,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          Align(
            alignment: const Alignment(2.7, -1.2),
            child: Container(
              height: MediaQuery.of(context).size.width / 1.3,
              width: MediaQuery.of(context).size.width / 1.3,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
            child: Container(),
          ),
          // Вміст сторінки
          Positioned.fill(
            child: child,
          ),
        ],
      ),
    );
  }
}
