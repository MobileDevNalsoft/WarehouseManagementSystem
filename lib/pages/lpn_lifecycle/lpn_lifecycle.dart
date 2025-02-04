import 'package:flutter/material.dart';

class LpnLifecycle extends StatefulWidget {
  const LpnLifecycle({super.key});

  @override
  State<LpnLifecycle> createState() => _LpnLifecycleState();
}

class _LpnLifecycleState extends State<LpnLifecycle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: const Color.fromRGBO(192, 208, 230, 1)),
    );
  }
}
