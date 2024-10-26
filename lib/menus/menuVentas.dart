// Importa las dependencias necesarias
import 'package:dulce_precision/database/providers/ventas_provider.dart';
import 'package:dulce_precision/models/font_size_model.dart';
import 'package:dulce_precision/models/theme_model.dart';
import 'package:dulce_precision/widgets/confirmGenerica_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Importa la pantalla de recetas

class MenuVentas extends StatelessWidget {
  const MenuVentas({super.key});

  @override
  Widget build(BuildContext context) {
        final themeModel = Provider.of<ThemeModel>(context); // Obtenemos el modelo de tema
    final fontSizeModel = Provider.of<FontSizeModel>(context); // Obtenemos el modelo de tamaño de fuente

    return PopupMenuButton<int>(
      // Ícono de tres puntos verticales que activa el menú
      icon: Icon(Icons.more_vert, size: fontSizeModel.iconSize,
                color:  themeModel.primaryIconColor ),
      onSelected: (int value) async {
        // Maneja la selección del menú con base en el valor
        switch (value) {
          case 1:
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => const SettingsScreen(),
            //   ),
            // ); // Navega a la pantalla de configuraciones
            break;
          case 2:
            // Muestra el modal de confirmación y espera la respuesta
            var msj = '¿Estás seguro de que deseas eliminar todas las ventas?';
            final confirmacion = await ConfirmDialog.mostrarConfirmacion(context, msj);

            if (confirmacion == true) {
              // Si el usuario confirma la eliminación
              try {
                // Llamamos al método para eliminar todo el contenido de la tabla 'recetas'
                // await recetasProvider.eliminarContenidoTablaRecetas();
                // Supongamos que tienes un botón o acción que llama a este método
                await Provider.of<VentasProvider>(context, listen: false)
                    .eliminarContenidoTablaVentas();

                // Muestra un mensaje de éxito si es necesario
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Todas las Ventas han sido eliminadas.')),
                );
              } catch (e) {
                // Manejo del error
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error al eliminar las Ventas: $e')),
                );
              }
            }
            break;// Navega a la pantalla de recetas
        }
      },
      itemBuilder: (BuildContext context) {
        final themeModel = Provider.of<ThemeModel>(context, listen: false);
        final fontSizeModel = Provider.of<FontSizeModel>(context, listen: false);

        // Construye las opciones del menú flotante
        return <PopupMenuEntry<int>>[
          PopupMenuItem<int>(
            value: 1, // Valor que se pasa al onSelected cuando se selecciona
            child: Text(
              '', 
              style: TextStyle(
                fontSize: fontSizeModel.textSize,
                color:  themeModel.secondaryTextColor 
              ),
            ),
          ),
          PopupMenuItem<int>(
            value: 2, // Valor que se pasa al onSelected cuando se selecciona
            child: Text(
              'Borrar todas las ventas',
              style: TextStyle(
                fontSize: fontSizeModel.textSize,
                color:  themeModel.secondaryTextColor 
              ),
            ),
          ),
        ];
      },
    );
  }
}
