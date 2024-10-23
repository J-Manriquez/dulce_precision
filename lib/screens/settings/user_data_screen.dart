import 'package:flutter/material.dart';

class UserDataScreen extends StatelessWidget {
  const UserDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Datos del usuario',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
