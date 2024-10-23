// Importa las dependencias necesarias
import 'package:dulce_precision/database/providers/gastosFijos_provider.dart';
import 'package:dulce_precision/models/font_size_model.dart';
import 'package:dulce_precision/models/theme_model.dart';
import 'package:dulce_precision/widgets/confirmGenerica_widget.dart';
import 'package:flutter/material.dart';
import 'package:dulce_precision/screens/settings/settings_screen.dart'; // Importa la pantalla de configuraciones
import 'package:provider/provider.dart'; // Importa la librería de provider

class MenuGastosFijos extends StatelessWidget {
  const MenuGastosFijos({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtenemos el modelo de tema y tamaño de fuente
    final themeModel = Provider.of<ThemeModel>(context);
    final fontSizeModel = Provider.of<FontSizeModel>(context);

    return PopupMenuButton<int>(
      // Ícono de tres puntos verticales que activa el menú
      icon: Icon(
        Icons.more_vert,
        color: themeModel.primaryIconColor,
        size: fontSizeModel.iconSize,
      ),
      onSelected: (int value) async {
        // Maneja la selección del menú con base en el valor
        switch (value) {
          case 1:
            // Navega a la pantalla de configuraciones
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SettingsScreen(),
              ),
            );
            break;
          case 2:
            // Muestra el modal de confirmación y espera la respuesta
            var msj = '¿Estás seguro de que deseas eliminar todos los gastos fijos?';
            final confirmacion = await ConfirmDialog.mostrarConfirmacion(context, msj);

            if (confirmacion == true) {
              // Si el usuario confirma la eliminación
              try {
                // Llama al método para eliminar todo el contenido de la tabla 'gastos_fijos'
                await Provider.of<GastosFijosProvider>(context, listen: false)
                    .eliminarContenidoTablaGastosFijos();

                // Muestra un mensaje de éxito si es necesario
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Todos los gastos fijos han sido eliminados.')),
                );
              } catch (e) {
                // Manejo del error
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error al eliminar los gastos fijos: $e')),
                );
              }
            }
            break;
        }
      },
      itemBuilder: (BuildContext context) {
        // Construye las opciones del menú flotante
        return <PopupMenuEntry<int>>[
          PopupMenuItem<int>(
            value: 1, // Valor que se pasa al onSelected cuando se selecciona
            child: Text(
              'Configuraciones',
              style: TextStyle(
                  fontSize: fontSizeModel.textSize,
                  color: themeModel.secondaryTextColor),
            ),
          ),
          PopupMenuItem<int>(
            value: 2, // Valor que se pasa al onSelected cuando se selecciona
            child: Text(
              'Borrar todos los gastos fijos',
              style: TextStyle(
                  fontSize: fontSizeModel.textSize,
                  color: themeModel.secondaryTextColor),
            ),
          ),
        ];
      },
    );
  }
}
