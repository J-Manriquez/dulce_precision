import 'package:flutter/material.dart';

// Función que muestra un diálogo con un indicador de progreso circular.
void refreshDialog(BuildContext context, {Color color = Colors.blue}) {
  // Muestra el diálogo utilizando el método showDialog.
  showDialog(
    context: context,
    barrierDismissible:
        false, // No permite cerrar el diálogo al tocar fuera de él.
    builder: (BuildContext context) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
              color), // Cambia el color del indicador.
        ), // Muestra un indicador de carga circular.
      );
    },
  );
}
