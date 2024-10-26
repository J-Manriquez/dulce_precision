// Importa las dependencias necesarias
import 'package:dulce_precision/database/providers/recetas_provider.dart';
import 'package:dulce_precision/models/font_size_model.dart';
import 'package:dulce_precision/models/theme_model.dart';
import 'package:dulce_precision/screens/recetas/recetasOnline/recetasOnline_screen.dart';
import 'package:dulce_precision/widgets/confirmGenerica_widget.dart';
import 'package:flutter/material.dart';
import 'package:dulce_precision/screens/settings/settings_screen.dart';
import 'package:provider/provider.dart'; // Importa la pantalla de configuraciones

class MenuRecetas extends StatelessWidget {
  const MenuRecetas({super.key});

  @override
  Widget build(BuildContext context) {
    final themeModel =
        Provider.of<ThemeModel>(context); // Obtenemos el modelo de tema
    final fontSizeModel = Provider.of<FontSizeModel>(
        context); // Obtenemos el modelo de tamaño de fuente

    return PopupMenuButton<int>(
      // Ícono de tres puntos verticales que activa el menú
      icon: Icon(
        Icons.more_vert,
        color: themeModel.primaryIconColor,
        size: fontSizeModel.iconSize,
      ),
      onSelected: (int value) async {
        // final themeModel = Provider.of<ThemeModel>(context, listen: false);
        // final fontSizeModel =
        //     Provider.of<FontSizeModel>(context, listen: false);

        // Marcamos la función como asíncrona
        // Maneja la selección del menú con base en el valor
        switch (value) {
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SettingsScreen(),
              ),
            ); // Navega a la pantalla de configuraciones
            break;
          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecetarioOnlineScreen(),
              ),
            ); // Navega a la pantalla de configuraciones
            break;
          case 3:
            // Muestra el modal de confirmación y espera la respuesta
            var msj = '¿Estás seguro de que deseas eliminar todas las recetas?';
            final confirmacion = await ConfirmDialog.mostrarConfirmacion(context, msj);

            if (confirmacion == true) {
              // Si el usuario confirma la eliminación
              try {
                // Llamamos al método para eliminar todo el contenido de la tabla 'recetas'
                // await recetasProvider.eliminarContenidoTablaRecetas();
                // Supongamos que tienes un botón o acción que llama a este método
                await Provider.of<RecetasProvider>(context, listen: false)
                    .eliminarContenidoTablaRecetas();

                // Muestra un mensaje de éxito si es necesario
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Todas las recetas han sido eliminadas.')),
                );
              } catch (e) {
                // Manejo del error
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error al eliminar las recetas: $e')),
                );
              }
            }
            break;
        }
      },

      itemBuilder: (BuildContext context) {
        final themeModel = Provider.of<ThemeModel>(context, listen: false);
        final fontSizeModel =
            Provider.of<FontSizeModel>(context, listen: false);

        // Construye las opciones del menú flotante
        return <PopupMenuEntry<int>>[
          PopupMenuItem<int>(
            value: 1, // Valor que se pasa al onSelected cuando se selecciona
            child: Text(
              'Evolucion de recetas',
              style: TextStyle(
                  fontSize: fontSizeModel.textSize,
                  color: themeModel.secondaryTextColor),
            ),
          ),
          PopupMenuItem<int>(
            value: 2, // Valor que se pasa al onSelected cuando se selecciona
            child: Text(
              'Recetario online',
              style: TextStyle(
                  fontSize: fontSizeModel.textSize,
                  color: themeModel.secondaryTextColor),
            ),
          ),
          PopupMenuItem<int>(
            value: 3, // Valor que se pasa al onSelected cuando se selecciona
            child: Text(
              'Borrar todas las recetas',
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
