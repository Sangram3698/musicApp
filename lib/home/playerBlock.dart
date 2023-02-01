import 'package:flutter/material.dart';

class Player extends StatelessWidget {
  final child;
  const Player({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Center(
        child: child,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Color.fromARGB(255, 250, 242, 242),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 222, 218, 218),
              blurRadius: 1000000,
              offset: Offset(4, 4),
            ),
            BoxShadow(
                color: Color.fromARGB(255, 220, 217, 217),
                blurRadius: 15,
                offset: Offset(-6, -6))
          ]),
    );
  }
}
